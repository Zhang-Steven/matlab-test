rosIP = '192.168.180.128';   % IP address of ROS-enabled machine  

rosinit(rosIP,11311); % Initialize ROS connection

edit exampleHelperFlowChartPickPlaceROSGazebo.sfx

load('exampleHelperKINOVAGen3GripperROSGazebo.mat');

initialRobotJConfig =  [0 0 0 2.513 0 -0.9424 -1.5708];
initialRobotJConfig000 =  [3.5797   -0.6562   -1.2507   -0.7008    0.7303   -2.0500   -1.9053];
endEffectorFrame = "gripper";

coordinator = exampleHelperCoordinatorPickPlaceROSGazebo(robot,initialRobotJConfig, endEffectorFrame);

coordinator.HomeRobotTaskConfig = getTransform(robot, initialRobotJConfig, endEffectorFrame); 
coordinator.PlacingPose{1} = trvec2tform([[0.2 0.55 0.26]])*axang2tform([0 0 1 pi/2])*axang2tform([0 1 0 pi]);
coordinator.PlacingPose{2} = trvec2tform([[0.2 -0.55 0.26]])*axang2tform([0 0 1 pi/2])*axang2tform([0 1 0 pi]);

coordinator.FlowChart = exampleHelperFlowChartPickPlaceROSGazebo('coordinator', coordinator); 

answer = questdlg('Do you want to start the pick-and-place job now?', ...
         'Start job','Yes','No', 'No');

switch answer
    case 'Yes'
        % Trigger event to start Pick and Place in the Stateflow Chart
        coordinator.FlowChart.startPickPlace;       
    case 'No'
        coordinator.FlowChart.endPickPlace;
        delete(coordinator.FlowChart)
        delete(coordinator);
end

% coordinator.FlowChart.endPickPlace;        
% delete(coordinator.FlowChart);
% delete(coordinator);