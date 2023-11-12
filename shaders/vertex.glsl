
out Vertex {
	vec4 position;
	vec4 color;
	float brightness;
} oVert;

//out vec4 color;  // varying vec4 color;
//out float brightness;  // varying float brightness;

void main()
{
	// gl_Position = uMatrix*vec4(gl_Vertex.xy,0,gl_Vertex.w);
	gl_Position = TDWorldToProj(TDDeform(P));

	// brightness = min(max(0.0,gl_Vertex.z),1.0);
	oVert.brightness = min(max(0.0,P.z),1.0);
	
#ifndef TD_PICKING_ACTIVE
	// color = gl_Color;
	//color = 
	oVert.color = Cd; //TDPointColor();
	oVert.position = gl_Position;
#else
	TDWritePickingValues();
#endif
}