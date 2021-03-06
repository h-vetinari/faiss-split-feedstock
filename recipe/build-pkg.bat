:: Build vanilla version (no avx2).
:: Do not use the Python3_* variants for cmake
cmake -B _build_python ^
    -DFAISS_ENABLE_GPU=OFF ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DPython_EXECUTABLE="%PYTHON%" ^
    faiss/python
if %ERRORLEVEL% neq 0 exit 1

cmake --build _build_python --config Release -j %CPU_COUNT%
if %ERRORLEVEL% neq 0 exit 1

:: Build actual python module.
pushd _build_python
%PYTHON% setup.py install --single-version-externally-managed --record=record.txt --prefix=%PREFIX%
if %ERRORLEVEL% neq 0 exit 1
popd
:: clean up cmake-cache between builds
rd /S /Q _build_python
