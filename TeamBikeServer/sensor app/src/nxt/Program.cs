using System;
using System.IO.Ports;
using NKH.MindSqualls;

namespace nxt
{
	class MainClass
	{
		static bool hasConnected = false;
		public static void Main (string[] args)
		{
			Console.WriteLine("NXT Server Bluetooth App");
			Console.WriteLine("----------------------------\n");
			Console.WriteLine("Attempting to connect to device...");
				foreach (string s in SerialPort.GetPortNames())
				{
					if (isNXT(getPortNumber(s)))
					{
					break;
					}
				}  
			if (!hasConnected)
				Console.WriteLine ("Failed to connect to NXT");

			Console.WriteLine ("Press any key to exit program.");
			Console.ReadLine ();
		}

		static void lightSensor_OnPolled(NxtPollable polledItem)
		{
			NxtLightSensor lightSensor = (NxtLightSensor) polledItem;
			byte? light = lightSensor.Intensity;

			String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><sensor-data><sensors><light>"+light+"</light></sensors></sensor-data>";
			String writePath = "sensor-data.xml";
			System.IO.StreamWriter file = new System.IO.StreamWriter(writePath);
			file.WriteLine(xml);
			file.Close();
		}

		static byte getPortNumber(String s) 
		{
			String portNumber = s.Substring(3);
			byte portInt;
			portInt = byte.Parse (portNumber);
			return portInt;
		}

		static bool isNXT(byte port){
			NxtBrick brick;
			try{
				brick = new NxtBrick(NxtCommLinkType.Bluetooth, port);
				brick.Connect();

				if(brick.Name == "NXT1"){
					Console.WriteLine("Connected to NXT1");
					hasConnected = true;
					runNXT(brick);
					return true;
				}
				else{
					brick.Disconnect();
					return false;
				}
			}catch(Exception e){
				return false;
			}
		}


		static void runNXT(NxtBrick brick){
			try
			{
				Console.WriteLine("Starting to poll light sensor");
				NxtLightSensor myLight = new NxtLightSensor();
				brick.Sensor3 = myLight;
				myLight.PollInterval = 1;
				myLight.OnPolled += new Polled(lightSensor_OnPolled);
				myLight.GenerateLight = true;

			}
			catch (Exception e)
			{
				Console.WriteLine ("no NXT device connected: \n"+e);
			}

		}
	}
}
