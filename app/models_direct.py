"""
Modelos SQLAlchemy para uso direto (sem Flask-SQLAlchemy).

Versão adaptada dos modelos para uso com SQLAlchemy direto.
"""

from sqlalchemy import Column, String, CheckConstraint
from app.database.db_session import Base


class CodigoAba(Base):
    """Modelo para tabela de códigos → abas."""
    __tablename__ = "codigo_aba"
    
    codigo = Column(String, primary_key=True)
    aba = Column(String, nullable=False)
    
    __table_args__ = (
        CheckConstraint("aba IN ('servidor', 'patronal-gilrat')", name="check_aba"),
    )


class CnpjUo(Base):
    """Modelo para tabela de CNPJ → UO Contribuinte."""
    __tablename__ = "cnpj_uo"
    
    cnpj = Column(String, primary_key=True)
    uo_contribuinte = Column(String, nullable=False)

