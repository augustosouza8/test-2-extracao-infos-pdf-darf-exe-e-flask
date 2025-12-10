"""
Configuração do SQLAlchemy para uso direto (sem Flask).

Fornece engine, session factory e acesso ao banco de dados
para uso na aplicação PyQt6.
"""

import os
import sys
from pathlib import Path
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base, Session

Base = declarative_base()

_engine = None
_SessionLocal = None


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
        base_dir = Path(__file__).parent.parent.parent
        db_path = base_dir / "config.db"
    
    return f"sqlite:///{db_path}"


def get_engine():
    """Retorna o engine SQLAlchemy (singleton)."""
    global _engine
    if _engine is None:
        database_url = get_database_url()
        _engine = create_engine(
            database_url,
            connect_args={"check_same_thread": False} if "sqlite" in database_url else {},
            echo=False
        )
    return _engine


def get_session_factory():
    """Retorna a factory de sessões SQLAlchemy (singleton)."""
    global _SessionLocal
    if _SessionLocal is None:
        _SessionLocal = sessionmaker(
            autocommit=False,
            autoflush=False,
            bind=get_engine()
        )
    return _SessionLocal


def get_session() -> Session:
    """
    Retorna uma nova sessão SQLAlchemy.
    
    IMPORTANTE: A sessão deve ser fechada após o uso (use context manager).
    """
    SessionLocal = get_session_factory()
    return SessionLocal()


def init_database():
    """
    Inicializa o banco de dados criando as tabelas se não existirem.
    """
    engine = get_engine()
    
    # Importa os modelos - isso registra as tabelas no Base.metadata
    # Precisa ser feito ANTES de create_all
    import app.models_direct  # noqa: F401
    
    # Cria todas as tabelas
    Base.metadata.create_all(bind=engine)


def close_engine():
    """Fecha o engine (útil para cleanup)."""
    global _engine
    if _engine:
        _engine.dispose()
        _engine = None

