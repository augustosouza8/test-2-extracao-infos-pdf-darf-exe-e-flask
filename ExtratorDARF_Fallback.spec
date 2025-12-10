# -*- mode: python ; coding: utf-8 -*-
from PyInstaller.utils.hooks import collect_submodules

hiddenimports = ['flask', 'flask.app', 'flask.blueprints', 'flask.ctx', 'flask.json', 'flask.sessions', 'flask.helpers', 'flask.templating', 'flask.wrappers', 'jinja2', 'jinja2.ext', 'markupsafe', 'werkzeug', 'werkzeug.utils', 'werkzeug.wrappers', 'werkzeug.wrappers.request', 'werkzeug.wrappers.response', 'flask_sqlalchemy', 'flask_migrate', 'sqlalchemy', 'sqlalchemy.engine', 'sqlalchemy.pool', 'sqlalchemy.sql', 'waitress', 'waitress.server', 'rapidocr_onnxruntime', 'pandas', 'openpyxl', 'pdfplumber', 'pdfminer', 'onnxruntime', 'cv2', 'PIL', 'PIL.Image', 'numpy', 'shapely', 'pyclipper', 'yaml']
hiddenimports += collect_submodules('flask')
hiddenimports += collect_submodules('jinja2')
hiddenimports += collect_submodules('werkzeug')
hiddenimports += collect_submodules('flask_sqlalchemy')
hiddenimports += collect_submodules('flask_migrate')
hiddenimports += collect_submodules('waitress')
hiddenimports += collect_submodules('rapidocr_onnxruntime')


a = Analysis(
    ['run_exe_fallback.py'],
    pathex=[],
    binaries=[],
    datas=[('app/templates', 'app/templates'), ('app/static', 'app/static'), ('ocr_models', 'ocr_models')],
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='ExtratorDARF_Fallback',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
