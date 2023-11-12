//#version 120
#extension GL_EXT_geometry_shader4 : enable

#define EPS 1E-6

layout(lines_adjacency) in;
layout(triangle_strip, max_vertices = 4) out;

in Vertex {
    vec4 position;
	vec4 color;
	float brightness;
} iVert[];

out Vertex {
    vec4 position;
	vec4 color;
	float brightness;
    vec3 texcoord;
    vec2 pos;
} oVert;

//out vec3 texcoord;
//out vec2 pos;
//out vec4 color;
uniform float uSize;
uniform mat4 uMatrix;

void main() {
    mat4 tmatrix = uMatrix;
    vec2 p0 = (iVert[0].position).xy;
    vec2 p1 = (iVert[1].position).xy;
    vec2 dir = p1 - p0;
    oVert.texcoord.z = length(dir);

    if (oVert.texcoord.z > EPS) {
        dir = dir / oVert.texcoord.z;
    } else {
        dir = vec2(1.0, 0.0);
    }

    vec2 norm = vec2(-dir.y, dir.x);

    dir *= uSize;
    norm *= uSize;

    oVert.texcoord.xy = vec2(-uSize, -uSize);
    oVert.color = iVert[0].color;
    gl_Position = tmatrix * vec4(p0 - dir - norm, 0.0, 1.0);
	oVert.pos = p0;
    oVert.position = gl_Position;
    EmitVertex();

    oVert.texcoord.xy = vec2(-uSize,  uSize);
    gl_Position = tmatrix * vec4(p0 - dir + norm, 0.0, 1.0);
    oVert.position = gl_Position;
    EmitVertex();

    oVert.texcoord.xy = vec2(oVert.texcoord.z + uSize, -uSize);
    gl_Position = tmatrix * vec4(p1 + dir - norm, 0.0, 1.0);
    oVert.position = gl_Position;
    EmitVertex();

    oVert.texcoord.xy = vec2(oVert.texcoord.z + uSize,  uSize);
    gl_Position = tmatrix * vec4(p1 + dir + norm, 0.0, 1.0);
    oVert.position = gl_Position;
    EmitVertex();

    EndPrimitive();
}
