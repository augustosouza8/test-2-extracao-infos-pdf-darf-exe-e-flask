"""
Factory para criação da aplicação Flask.

Centraliza a criação e configuração do app Flask usando o padrão factory.
"""

import os
import sys
from pathlib import Path
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

from app.config import Config
from app.routes import main, api

# Instâncias do Flask-SQLAlchemy e Flask-Migrate
# Devem ser criadas fora da função para evitar problemas de import circular
db = SQLAlchemy()
migrate = Migrate()


def get_database_url() -> str:
    """
    Retorna a URL de conexão do banco de dados.
    
    Prioridade:
    1. DATABASE_URL (PostgreSQL no Azure/Render)
    2. SQLite no diretório do usuário (executável)
    3. SQLite local (desenvolvimento)
    """
    # PostgreSQL (produção)
    database_url = os.getenv("DATABASE_URL")
    if database_url:
        # Azure/Render pode fornecer postgres:// mas SQLAlchemy precisa postgresql://
        if database_url.startswith("postgres://"):
            database_url = database_url.replace("postgres://", "postgresql://", 1)
        return database_url
    
    # Detecta se está rodando como executável (PyInstaller)
    is_frozen = getattr(sys, 'frozen', False)
    
    if is_frozen:
        # Executável: usa diretório de dados do usuário
        appdata_dir = os.getenv('APPDATA')
        if not appdata_dir:
            # Fallback se APPDATA não estiver definido
            appdata_dir = os.path.expanduser('~')
        
        data_dir = os.path.join(appdata_dir, 'ExtratorDARF')
        os.makedirs(data_dir, exist_ok=True)
        db_path = os.path.join(data_dir, 'config.db')
    else:
        # Desenvolvimento: usa diretório do projeto
        base_dir = Path(__file__).parent.parent
        db_path = base_dir / "config.db"
    
    return f"sqlite:///{db_path}"


def create_app(config_class=Config):
    """
    Cria e configura a aplicação Flask.
    
    Args:
        config_class: Classe de configuração a usar
        
    Returns:
        Instância configurada do Flask app
    """
    # Flask procura por 'templates' e 'static' dentro do diretório do app
    # Especificamos caminhos relativos ao diretório do módulo (app/)
    app_dir = Path(__file__).parent
    app = Flask(
        __name__,
        template_folder=str(app_dir / 'templates'),
        static_folder=str(app_dir / 'static')
    )
    
    # Aplica configurações
    config = config_class()
    app.secret_key = config.SECRET_KEY
    app.config["MAX_CONTENT_LENGTH"] = config.MAX_CONTENT_LENGTH
    app.config["UPLOAD_FOLDER"] = config.UPLOAD_FOLDER
    
    # Configuração do banco de dados
    app.config["SQLALCHEMY_DATABASE_URI"] = get_database_url()
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["SQLALCHEMY_ENGINE_OPTIONS"] = {
        "pool_pre_ping": True,  # Verifica conexões antes de usar (importante para PostgreSQL)
        "pool_recycle": 300,  # Recicla conexões após 5 minutos (importante para Azure)
    }
    
    # Inicializa Flask-SQLAlchemy e Flask-Migrate
    db.init_app(app)
    migrate.init_app(app, db)
    
    # Importa modelos após inicializar db para registro correto
    from app import models  # noqa: F401
    
    # Se for executável, inicializa banco automaticamente se não existir
    is_frozen = getattr(sys, 'frozen', False)
    if is_frozen:
        with app.app_context():
            try:
                db.create_all()
            except Exception:
                # Ignora erros se tabelas já existirem
                pass
    
    # Registra blueprints
    app.register_blueprint(main.bp)
    app.register_blueprint(api.bp)
    
    # Comando CLI para inicialização do banco de dados
    @app.cli.command("init-db")
    def init_db_command():
        """Inicializa o banco de dados e popula com dados padrão."""
        from app.database import init_db_data
        
        try:
            db.create_all()
            print("Tabelas criadas com sucesso.")
            
            init_db_data()
            print("Dados padrão populados com sucesso.")
        except Exception as e:
            print(f"Erro ao inicializar banco de dados: {e}")
            raise
    
    return app


# Cria instância do app para compatibilidade com gunicorn app:app
# Isso permite que tanto wsgi:app quanto app:app funcionem
app = create_app()
