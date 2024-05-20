#version 410 core
#include "../common/lights.glsl"

layout(location = 0) in vec3 vertex_position;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec2 texture_coordinate;

out VertexOut {
    vec2 texture_coordinate;
    vec3 ws_position;
    vec3 ws_normal;
    Material material;
} vertex_out;

uniform mat4 model_matrix;
uniform mat3 normal_matrix;
uniform vec3 ws_view_position;
uniform mat4 projection_view_matrix;
uniform vec3 diffuse_tint;
uniform vec3 specular_tint;
uniform vec3 ambient_tint;
uniform float shininess;
uniform float texture_scale;

void main() {
    vec3 ws_position = (model_matrix * vec4(vertex_position, 1.0)).xyz;
    vec3 ws_normal = normalize(normal_matrix * normal);

    vertex_out.texture_coordinate = texture_coordinate * texture_scale;
    vertex_out.ws_position = ws_position;
    vertex_out.ws_normal = ws_normal;

    Material material = Material(diffuse_tint, specular_tint, ambient_tint, shininess);
    vertex_out.material = material;

    gl_Position = projection_view_matrix * vec4(ws_position, 1.0);
}
