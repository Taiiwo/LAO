#version 330 core
//  in vec3 fragmentColor;
in vec2 UV;
out vec4 color;

void main()
{
//    color = fragmentColor;
//    color = texture(diffuse, UV).rgba;
    color = vec4(1.0, 1.0, 1.0, 1.0);
}
