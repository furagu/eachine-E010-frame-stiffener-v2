$fn=100;

THE_HOLY_NUMBER = 0.402;
function bless(x) = floor(x / THE_HOLY_NUMBER) * THE_HOLY_NUMBER;

    // motor_to_motor_length = 44.44,
    // motor_to_motor_width  = 47.44,

    // motor_to_motor_length = 46.46,
    // motor_to_motor_width  = 45.46,

    // motor_to_motor_length = 45.965,
    // motor_to_motor_width  = 45.965,


the_thing(
    motor_to_motor_length = 47,
    motor_to_motor_width  = 45.5,
    arms_width            = THE_HOLY_NUMBER * 2,
    height                = 2,
    cage_angle            = 14,
    cage_chamfer          = 0.2,
    motor_diameter        = 6.5,
    pod_diameter          = 8.15,
    pod_width             = 4.15,
    thickness             = THE_HOLY_NUMBER * 2
);

module the_thing() {
    arm_length = sqrt(pow(motor_to_motor_length, 2) + pow(motor_to_motor_width, 2)) / 2;
    diagonal_angle = atan(motor_to_motor_width / motor_to_motor_length);

    echo(arm_length * 2);

    cage_height = height;
    cage_x = motor_to_motor_length / 2;
    cage_y = motor_to_motor_width / 2;

    cage_positons = [
        [[+cage_x, +cage_y], diagonal_angle,       -cage_angle],
        [[-cage_x, +cage_y], 180 - diagonal_angle, +cage_angle],
        [[-cage_x, -cage_y], 180 + diagonal_angle, -cage_angle],
        [[+cage_x, -cage_y], 360 - diagonal_angle, +cage_angle],
    ];

    difference() {
        union() {
            translate([-motor_to_motor_length / 2, -motor_to_motor_width / 2, 0])
                base(
                    l = motor_to_motor_length,
                    w = motor_to_motor_width,
                    h = height,
                    width = arms_width
                );
            for (p = cage_positons) {
                translate([p[0][0], p[0][1], 0])
                rotate([0, 0, p[1] + p[2]])
                linear_extrude(cage_height)
                offset(r=thickness)
                    cage_base(motor_diameter, pod_diameter, pod_width, thickness, cage_chamfer);
            }
        }

        for (p = cage_positons) {
            translate([p[0][0], p[0][1], -1])
            rotate([0, 0, p[1] + p[2]])
            linear_extrude(cage_height + 2)
                cage_base(motor_diameter, pod_diameter, pod_width, thickness, cage_chamfer);
        }
    }

}

module base() {
    difference() {
        cube(size=[l, w, h]);

        translate([width, width, -1])
            cube(size=[l - width * 2, w - width * 2, h + 2]);
    }
}

module cage_base(motor_diameter, pod_diameter, pod_width, thickness, chamfer) {
    union() {
        cage_pod(pod_diameter, pod_width, chamfer);
        offset(r=-chamfer)
        union() {
            cage_pod(pod_diameter, pod_width + chamfer * 2, chamfer);
            circle(d=motor_diameter + chamfer * 2);
            translate([-motor_diameter / 2.6, 0]) circle(d=motor_diameter / 2.1 + chamfer * 2);
        }
    }
}

module cage_pod(pod_diameter, pod_width, chamfer) {
    offset(r=chamfer)
    difference() {
        circle(d=pod_diameter - chamfer * 2);
        translate([+pod_width / 2 - chamfer, -pod_diameter / 2]) square([pod_diameter, pod_diameter]);
        translate([-(pod_diameter + pod_width / 2) + chamfer, -pod_diameter / 2]) square([pod_diameter, pod_diameter]);
    }
}
