using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.SBZ
{
	class SwingingSpikeball : ObjectDefinition
	{
		private int[] labels = { 0, 1, 2 };
		private Sprite imgwreckingball;
		private List<Sprite> imgs = new List<Sprite>();

		public override void Init(ObjectData data)
		{
			imgwreckingball = ObjectHelper.MapASMToBmp(ObjectHelper.OpenArtFile("../artnem/GHZ Giant Ball.bin", CompressionType.Nemesis), "../_maps/GHZ Ball.asm", 1, 2);
			for (int i = 0; i < labels.Length; i++)
				imgs.Add(ObjectHelper.MapASMToBmp(ObjectHelper.OpenArtFile("../artnem/SYZ Large Spikeball.bin", CompressionType.Nemesis), "../_maps/Big Spiked Ball.asm", labels[i], i == 2 ? 2 : 0));
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 }); }
		}

		public override string Name
		{
			get { return "Swinging Spikeball"; }
		}

		public override bool RememberState
		{
			get { return false; }
		}

		public override string SubtypeName(byte subtype)
		{
			if ((subtype & 0x10) != 0)
				return (subtype & 0x0F) + " links + wrecking ball";
			else
				return (subtype & 0x0F) + " links";
		}

		public override Sprite Image
		{
			get { return imgs[0]; }
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			if ((subtype & 0x10) != 0)
				return imgwreckingball;
			else
				return imgs[0];
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			int length = obj.SubType & 0x0F;
			List<Sprite> sprs = new List<Sprite>() { imgs[2] };
			int yoff = 16;
			for (int i = 0; i < length; i++)
			{
				Sprite tmp = new Sprite(imgs[1]);
				tmp.Offset(0, yoff);
				sprs.Add(tmp);
				yoff += 16;
			}
			yoff -= 8;
			Sprite tm2 = new Sprite(SubtypeImage(obj.SubType));
			tm2.Offset(0, yoff);
			sprs.Add(tm2);
			return new Sprite(sprs.ToArray());
		}

		private PropertySpec[] customProperties = new PropertySpec[] {
			new PropertySpec("Chainlinks", typeof(int), "Extended", null, null, GetChainlinks, SetChainlinks),
			new PropertySpec("Wrecking Ball", typeof(bool), "Extended", null, null, GetWreckingBall, SetWreckingBall)
		};

		public override PropertySpec[] CustomProperties
		{
			get
			{
				return customProperties;
			}
		}

		private static object GetChainlinks(ObjectEntry obj)
		{
			return obj.SubType & 0x0F;
		}

		private static void SetChainlinks(ObjectEntry obj, object value)
		{
			value = Math.Max(0, (Math.Min(0x0D, (int)value)));
			obj.SubType = (byte)((obj.SubType & ~0x0F) | (int)value);
		}

		private static object GetWreckingBall(ObjectEntry obj)
		{
			return (obj.SubType & 0x10) != 0 ? true : false;
		}

		private static void SetWreckingBall(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~0x10) | ((bool)value == true ? 0x10 : 0));
		}
	}
}
