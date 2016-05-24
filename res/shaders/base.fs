#version 330 core
//  in vec3 fragmentColor;
in vec2 UV;
out vec3 color;
uniform sampler2D diffuse;

void main()
{
//    color = fragmentColor;
//    color = texture(diffuse, UV).rgba;
    color = vec3(1,1,1);
}
