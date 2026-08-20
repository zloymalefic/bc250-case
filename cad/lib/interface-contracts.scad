// Mechanical interface contracts shared by every part that mates to the case.
// Change interfaces here, never independently in a cover and its receiver.

case_body = [330, 155, 195];
case_wall = 4;
case_chamfer = 16;

front_contract_size = [155, 195, 12];
front_contract_screws = [[18, 18], [137, 18], [18, 177], [137, 177]];
front_button_opening = [45.2, 32.3];
front_button_origin = [15, 148];
front_usb_opening = [28.6, 71];
front_usb_origin = [111, 87];
front_usb_face = [27.93, 70.35, 3];

intake_contract_half = [130, 131, 4];
intake_contract_gap = 10;
intake_contract_origin_x = [30, 170];
intake_contract_z = 32;
intake_contract_magnet_local = [[24, 4], [106, 4],
                                [24, 127], [106, 127]];

esp_contract_opening = [74, 28];
esp_contract_cover = [98, 32, 3];
// Four side snaps: X axes coincide with the vertical opening edges, while the
// two Y levels stay clear of both the bottom chamfer and intake cover above.
esp_contract_snap_x = [12, 86];
esp_contract_snap_y = [10, 24];

rear_contract_screw_y = [30, 125];
rear_contract_screw_z = [5, 190];
rear_contract_horizontal_depth = 6;
rear_contract_vertical_depth = 44;

psu_contract_face = [110, 46.34];
psu_contract_rear_inner_x = 318;
