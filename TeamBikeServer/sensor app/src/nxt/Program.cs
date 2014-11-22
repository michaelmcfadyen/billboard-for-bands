using System;
using System.IO.Ports;
using NKH.MindSqualls;

namespace nxt
{
	class MainClass
	{
		static NxtBrick brick = new NxtBrick(0);
		public static void Main (string[] args)
		{

				foreach (string s in SerialPort.GetPortNames())
				{
					if (isNXT(getPortNumber(s)))
					{
					break;
					}
				}  

			Console.ReadLine ();
		}

		static void lightSensor_OnPolled(NxtPollable polledItem)
		{
			NxtLightSensor lightSensor = (NxtLightSensor) polledItem;
			byte? light = lightSensor.Intensity;

			String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><sensor-data><sensors><light>"+light+"</light></sensors></sensor-data>";
			String writePath = "..//sensor-data.xml";
			System.IO.StreamWriter file = new System.IO.StreamWriter(writePath);
			file.WriteLine(xml);
			file.Close();
			Console.WriteLine (light);
		}

		static byte getPortNumber(String s) 
		{
			String portNumber = s.Substring(3);
			byte portInt;
			byte.TryParse(portNumber, out portInt);
			return portInt;
		}

		static bool isNXT(byte port){
			try{
			brick = new NxtBrick(port);
			brick.Connect();
				if(brick.Name == "NXT1"){
					runNXT(brick);
				}
			return true;
			}catch(Exception e){
				brick.Disconnect ();
				return false;
			}
		}


		static void runNXT(NxtBrick brick){
			try
			{
				Console.WriteLine(brick.Name);
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
