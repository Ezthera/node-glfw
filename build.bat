echo %0 %1 %2

cd %2
cd deps
cd glfw-3.0.4
del CMakeCache.txt

IF /I "%1"=="x64" (
	cmake -DBUILD_SHARED_LIBS=1 -DGLFW_BUILD_EXAMPLES=0 -DGLFW_BUILD_TESTS=0 -DGLFW_BUILD_DOCS=0 -DCMAKE_GENERATOR_PLATFORM=x64 . > NUL
) else (
	cmake -DBUILD_SHARED_LIBS=1 -DGLFW_BUILD_EXAMPLES=0 -DGLFW_BUILD_TESTS=0 -DGLFW_BUILD_DOCS=0 . > NUL
)

IF errorlevel 1 (
	echo "GLFW cmake failed"
	exit 1
)

msbuild GLFW.sln /nologo /noconlog /p:Configuration=Release /m:4
IF errorlevel 1 (
	echo "GLFW Visual Stuio build (msbuild) failed"
	exit 1
) else (
	echo "Success: GLFW is built"
	exit 0
)
