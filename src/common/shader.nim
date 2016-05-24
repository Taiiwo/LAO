# import ../../external/glad/gl
import opengl

proc logShader(shader: GLuint) =
   var length: GLint = 0
   glGetShaderiv(shader, GL_INFO_LOG_LENGTH, length.addr)
   var log: string = newString(length.int)
   glGetShaderInfoLog(shader, length, nil, log)
   echo "Log: ", log


proc loadShader(typ: GLenum, file: string): GLuint =
  echo "Loading shader '", file, "'..."
  if typ != GL_VERTEX_SHADER and typ != GL_FRAGMENT_SHADER:
    return 0
  var
    fromfile: array[1, string] = [readFile(file).string]
    source = allocCStringArray(fromfile)
    compiled: GLint = 0
  result = glCreateShader(typ)
  glShaderSource(result, 1, source, nil)
  glCompileShader(result)
  glGetShaderiv(result, GL_COMPILE_STATUS, compiled.addr)
  if compiled == 0:
    logShader(result)
  deallocCStringArray(source)


proc loadShaderSet*(vertex_file_path: string, fragment_file_path: string): GLuint =
  var id_vertexshader = loadShader(GL_VERTEX_SHADER, vertex_file_path)
  var id_fragmentshader = loadShader(GL_FRAGMENT_SHADER, fragment_file_path)
  var programId = glCreateProgram()
  glAttachShader(programId, id_vertexshader)
  glAttachShader(programId, id_fragmentshader)
  glLinkProgram(programId)

  glDeleteShader(id_vertexshader)
  glDeleteShader(id_fragmentshader)

  return programId
