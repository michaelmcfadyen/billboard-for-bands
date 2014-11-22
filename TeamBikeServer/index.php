<?php

// Load XML
$xml=simplexml_load_file("sensor-data.xml");


// Get the light sensor data
$lightSensor = intval($xml->sensors[0]->light);


$arr = array('light' => $lightSensor);

echo json_encode($arr);

?>
