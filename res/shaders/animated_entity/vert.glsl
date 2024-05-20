#version 410 core
#include "../common/lights.glsl"
#include "../common/maths.glsl"

layout(location = 0) in vec3 vertex_position;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec2 texture_coordinate;
layout(location = 3) in vec4 bone_weights;
layout(location = 4) in uvec4 bone_indices;

out VertexOut {
    vec2 texture_coordinate;
    vec3 ws_position;
    vec3 ws_normal;
    Material material;
} vertex_out;

uniform mat4 model_matrix;
uniform vec3 diffuse_tint;
uniform vec3 specular_tint;
uniform vec3 ambient_tint;
uniform float shininess;
uniform float texture_scale;
uniform mat4 bone_transforms[BONE_TRANSFORMS];
uniform mat4 projection_view_matrix;

void main() {
    mat4 bone_transform = bone_weights[0] * bone_transforms[bone_indices[0]]
                        + bone_weights[1] * bone_transforms[bone_indices[1]]
                        + bone_weights[2] * bone_transforms[bone_indices[2]]
                        + bone_weights[3] * bone_transforms[bone_indices[3]];

    mat4 animation_matrix = model_matrix * bone_transform;
    mat3 normal_matrix = mat3(transpose(inverse(animation_matrix)));

    vec3 ws_position = (animation_matrix * vec4(vertex_position, 1.0)).xyz;
    vec3 ws_normal = normalize(normal_matrix * normal);

    vertex_out.texture_coordinate = texture_coordinate * texture_scale;
    vertex_out.ws_position = ws_position;
    vertex_out.ws_normal = ws_normal;
    vertex_out.material = Material(diffuse_tint, specular_tint, ambient_tint, shininess);

    gl_Position = projection_view_matrix * vec4(ws_position, 1.0);
}
