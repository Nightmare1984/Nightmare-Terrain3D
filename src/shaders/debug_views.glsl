// Copyright © 2025 Cory Petkovsek, Roope Palmroos, and Contributors.

// These special inserts are injected into the shader code at the end of fragment().
// Variables should be prefaced with __ to avoid name conflicts.

R"(
//INSERT: DEBUG_CHECKERED
	// Show a checkered grid
	vec2 __p = uv * 1.0; // scale
	vec2 __ddx = dFdx(__p);
	vec2 __ddy = dFdy(__p);
	vec2 __w = max(abs(__ddx), abs(__ddy)) + 0.01;
	vec2 __i = 2.0 * (abs(fract((__p - 0.5 * __w) / 2.0) - 0.5) - abs(fract((__p + 0.5 * __w) / 2.0) - 0.5)) / __w;
	ALBEDO = vec3((0.5 - 0.5 * __i.x * __i.y) * 0.2 + 0.2);
	ROUGHNESS = 0.7;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_GREY
	// Show all grey
	ALBEDO = vec3(0.2);
	ROUGHNESS = 0.7;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_HEIGHTMAP
	// Show heightmap
	ALBEDO = vec3(smoothstep(-0.1, 2.0, 0.5 + v_vertex.y/300.0));
	ROUGHNESS = 0.7;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_COLORMAP
	// Show colormap
	ALBEDO = color_map.rgb;
	ROUGHNESS = 0.7;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_ROUGHMAP
	// Show roughness map
	ALBEDO = vec3(color_map.a);
	ROUGHNESS = 0.7;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_CONTROL_TEXTURE
	
	// Show control map texture selection
	vec3 __t_colors[32];
	__t_colors[0] = vec3(1.0, 0.0, 0.0);
	__t_colors[1] = vec3(0.0, 1.0, 0.0);
	__t_colors[2] = vec3(0.0, 0.0, 1.0);
	__t_colors[3] = vec3(1.0, 0.0, 1.0);
	__t_colors[4] = vec3(0.0, 1.0, 1.0);
	__t_colors[5] = vec3(1.0, 1.0, 0.0);
	__t_colors[6] = vec3(0.2, 0.0, 0.0);
	__t_colors[7] = vec3(0.0, 0.2, 0.0);
	__t_colors[8] = vec3(0.0, 0.0, 0.35);
	__t_colors[9] = vec3(0.2, 0.0, 0.2);
	__t_colors[10] = vec3(0.0, 0.2, 0.2);
	__t_colors[11] = vec3(0.2, 0.2, 0.0);
	__t_colors[12] = vec3(0.1, 0.0, 0.0);
	__t_colors[13] = vec3(0.0, 0.1, 0.0);
	__t_colors[14] = vec3(0.0, 0.0, 0.15);
	__t_colors[15] = vec3(0.1, 0.0, 0.1);
	__t_colors[16] = vec3(0.0, 0.1, 0.1);
	__t_colors[17] = vec3(0.1, 0.1, 0.0);
	__t_colors[18] = vec3(0.2, 0.05, 0.05);
	__t_colors[19] = vec3(0.1, 0.3, 0.1);
	__t_colors[20] = vec3(0.05, 0.05, 0.2);
	__t_colors[21] = vec3(0.1, 0.05, 0.2);
	__t_colors[22] = vec3(0.05, 0.15, 0.2);
	__t_colors[23] = vec3(0.2, 0.2, 0.1);
	__t_colors[24] = vec3(1.0);
	__t_colors[25] = vec3(0.5);
	__t_colors[26] = vec3(0.35);
	__t_colors[27] = vec3(0.25);
	__t_colors[28] = vec3(0.15);
	__t_colors[29] = vec3(0.1);
	__t_colors[30] = vec3(0.05);
	__t_colors[31] = vec3(0.0125);
	vec3 __ctrl_base = __t_colors[mat[3].base];
	vec3 __ctrl_over = __t_colors[mat[3].over];
	float base_over = (length(fract(uv) - 0.5) < fma(mat[3].blend, 0.45, 0.1) ? 1.0 : 0.0);
	ALBEDO = mix(__ctrl_base, __ctrl_over, base_over);	
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_CONTROL_ANGLE
	ivec3 __auv = get_index_coord(floor(uv), SKIP_PASS);
	uint __a_control = texelFetch(_control_maps, __auv, 0).r;
	uint __angle = (__a_control >>10u & 0xFu);
	vec3 __a_colors[16] = {
		vec3(1., .2, .0), vec3(.8, 0., .2), vec3(.6, .0, .4), vec3(.4, .0, .6),
		vec3(.2, 0., .8), vec3(.1, .1, .8), vec3(0., .2, .8), vec3(0., .4, .6),
		vec3(0., .6, .4), vec3(0., .8, .2), vec3(0., 1., 0.), vec3(.2, 1., 0.),
		vec3(.4, 1., 0.), vec3(.6, 1., 0.), vec3(.8, .6, 0.), vec3(1., .4, 0.)
	};
	ALBEDO = __a_colors[__angle];
	ROUGHNESS = 1.;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_CONTROL_SCALE
	ivec3 __suv = get_index_coord(floor(uv), SKIP_PASS);
	uint __s_control = texelFetch(_control_maps, __suv, 0).r;
	uint __scale = (__s_control >>7u & 0x7u);
	vec3 __s_colors[8] = {
		vec3(.5, .5, .5), vec3(.675, .25, .375), vec3(.75, .125, .25), vec3(.875, .0, .125), vec3(1., 0., 0.),
		vec3(0., 0., 1.), vec3(.0, .166, .833), vec3(.166, .333, .666)
	};
	ALBEDO = __s_colors[__scale];
	ROUGHNESS = 1.;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5 ,0.5 ,1.0);
	AO = 1.0;

//INSERT: DEBUG_CONTROL_BLEND
	// Show control map blend values
	float __ctrl_blend = mat[3].blend;
	ALBEDO = vec3(__ctrl_blend);
	ROUGHNESS = 1.;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_AUTOSHADER
	ivec3 __ruv = get_index_coord(floor(uv), SKIP_PASS);
	uint __control = texelFetch(_control_maps, __ruv, 0).r;
	float __autoshader = float( bool(__control & 0x1u) || __ruv.z<0 );
	ALBEDO = vec3(__autoshader);
	ROUGHNESS = 1.;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_TEXTURE_HEIGHT
	// Show height textures
	ALBEDO = vec3(albedo_height.a);
	ROUGHNESS = 0.7;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_TEXTURE_NORMAL
	// Show normal map textures
	ALBEDO = pack_normal(normal_rough.rgb);
	ROUGHNESS = 0.7;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_TEXTURE_ROUGHNESS
	// Show roughness textures
	ALBEDO = vec3(normal_rough.a);
	ROUGHNESS = 0.7;
	SPECULAR = 0.;
	NORMAL_MAP = vec3(0.5, 0.5, 1.0);
	AO = 1.0;

//INSERT: DEBUG_REGION_GRID
	// Show region grid
	vec3 __pixel_pos1 = (INV_VIEW_MATRIX * vec4(VERTEX,1.0)).xyz;
	float __region_line = 1.0;		// Region line thickness
	__region_line *= .1*sqrt(length(_camera_pos - __pixel_pos1));
	if (mod(__pixel_pos1.x * _vertex_density + __region_line*.5, _region_size) <= __region_line || 
		mod(__pixel_pos1.z * _vertex_density + __region_line*.5, _region_size) <= __region_line ) {
		ALBEDO = vec3(1.);
	}

//INSERT: DEBUG_VERTEX_GRID
	// Show vertex grids
	vec3 __pixel_pos2 = (INV_VIEW_MATRIX * vec4(VERTEX,1.0)).xyz;
	float __grid_line = 0.05;		// Vertex grid line thickness
	float __grid_step = 1.0;			// Vertex grid size, 1.0 == integer units
	float __vertex_size = 4.;		// Size of vertices
	float __view_distance = 300.0;	// Visible distance of grid
	vec3 __vertex_mul = vec3(0.);
	vec3 __vertex_add = vec3(0.);
	float __distance_factor = clamp(1.-length(_camera_pos - __pixel_pos2)/__view_distance, 0., 1.);
	// Draw vertex grid
	if ( mod(__pixel_pos2.x * _vertex_density + __grid_line*.5, __grid_step) < __grid_line || 
	  	 mod(__pixel_pos2.z * _vertex_density + __grid_line*.5, __grid_step) < __grid_line ) { 
		__vertex_mul = vec3(0.5) * __distance_factor;
	}
	// Draw Vertices
	if ( mod(UV.x + __grid_line*__vertex_size*.5, __grid_step) < __grid_line*__vertex_size &&
	  	 mod(UV.y + __grid_line*__vertex_size*.5, __grid_step) < __grid_line*__vertex_size ) { 
		__vertex_add = vec3(0.15) * __distance_factor;
	}
	ALBEDO = fma(ALBEDO, 1.-__vertex_mul, __vertex_add);

//INSERT: DEBUG_INSTANCER_GRID
	// Show region grid
	vec3 __pixel_pos3 = (INV_VIEW_MATRIX * vec4(VERTEX,1.0)).xyz;
	float __cell_line = 0.5;		// Cell line thickness
	__cell_line *= .1*sqrt(length(_camera_pos - __pixel_pos3));
	#define CELL_SIZE 32
	if (mod(__pixel_pos3.x * _vertex_density + __cell_line*.5, CELL_SIZE) <= __cell_line || 
		mod(__pixel_pos3.z * _vertex_density + __cell_line*.5, CELL_SIZE) <= __cell_line ) {
		ALBEDO = vec3(.033);
	}

)"