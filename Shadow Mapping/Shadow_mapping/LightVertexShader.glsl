/*
Title: Shadow mapping (Hard Shadows)
File Name: LightVertexShader.glsl
Copyright � 2015
Original authors: Srinivasan Thiagarajan
Written under the supervision of David I. Schwartz, Ph.D., and
supported by a professional development seed grant from the B. Thomas
Golisano College of Computing & Information Sciences
(https://www.rit.edu/gccis) at the Rochester Institute of Technology.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Description:
This example demonstrates the implementation of shadow mapping
technique. In this example we render two spheres and a plane on the
bottom to highlight the shadows.

In the first pass, we render from the perspective of the light source.
In this example the light is on top and is projected downwards. In this 
rendering pass, the depth is stored onto a texture.

In the second pass, render the vertex normally. We convert the vertex 
positions in to the "light's" view space by multiplying it with the 
shadow matrix. The shadow matrix is computed by multiplying the bias 
matrix with the view and projection matrix as calculated from the 
perspective of the light. The bias matrix converts the the coordinates
from clipping coordinates (-1 to 1) to texture coordinates (0 to 1).

Using this texture coordinates, we retrieve the value from the depth map,
if the z value of the current point is less than that of the one retrieved, 
then it means light is incident on it. We calculate the color of that pixel
taking the light into consideration. Otherwise, we just shade the pixel its
albedo color.

References:
OpenGL 4 Shading language Cookbook
*/

#version 430 core // Identifies the version of the shader, this line must be on a separate line from the rest of the shader code
 
layout(location = 0) in vec3 in_position;	// Get in a vec3 for position
layout(location = 1) in vec3 in_normal;
layout(location = 2) in vec4 in_color;		// Get in a vec4 for color

out vec3 Position;
out vec3 Normal;
out vec4 Albedo;
out vec4 ShadowCoord;

uniform mat4 MVP;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;
uniform mat4 ShadowMatrix;

void main(void)
{
	// Forward data to fragment shader
	Position = (ModelViewMatrix * vec4(in_position,1.0f)).xyz;
	Normal = NormalMatrix * in_normal;
	Albedo = in_color;
	// Convert the coordinates from model space to clip coordinates from the perspective of the light source.
	ShadowCoord = ShadowMatrix * vec4(in_position, 1.0f);

	gl_Position = MVP * vec4(in_position, 1.0f);
}