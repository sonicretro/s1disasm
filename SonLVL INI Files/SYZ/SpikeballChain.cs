using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.SYZ
{
	class SpikeballChain : ObjectDefinition
	{
		private Sprite img;

		public override void Init(ObjectData data)
		{
			img = ObjectHelper.MapASMToBmp(ObjectHelper.OpenArtFile("../artnem/SYZ Small Spikeball.bin", CompressionType.Nemesis), "../_maps/Spiked Ball and Chain (SYZ).asm", 0, 0);
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new List<byte>()); }
		}

		public override string Name
		{
			get { return "Spikeball Chain"; }
		}

		public override bool RememberState
		{
			get { return false; }
		}

		public override string SubtypeName(byte subtype)
		{
			return string.Empty;
		}

		public override Sprite Image
		{
			get { return img; }
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return img;
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			int length = (obj.SubType & 0x0F) + 1;
			List<Sprite> sprs = new List<Sprite>();
			int yoff = 0;
			for (int i = 0; i < length; i++)
			{
				Sprite tmp = new Sprite(img);
				tmp.Offset(0, yoff);
				sprs.Add(tmp);
				yoff -= 16;
			}
			return new Sprite(sprs.ToArray());
		}

		private PropertySpec[] customProperties = new PropertySpec[] {
			new PropertySpec("Spikeballs", typeof(int), "Extended", null, null, GetChainlinks, SetChainlinks),
			new PropertySpec("Speed", typeof(int), "Speed", null, null, GetSpeed, SetSpeed),
			new PropertySpec("Rotation", typeof(ChainRotation), "Extended", null, null, GetRotation, SetRotation)
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
			return (obj.SubType & 0x07) + 1;
		}

		private static void SetChainlinks(ObjectEntry obj, object value)
		{
			value = Math.Max(1, (Math.Min(0x07, ((int)value - 1))));
			obj.SubType = (byte)((obj.SubType & ~0x07) | ((int)value - 1));
		}

		private static object GetSpeed(ObjectEntry obj)
		{
			if ((obj.SubType & 0x80) == 0x80)
				return (((~obj.SubType & 0xF0) >> 4) + 1);
			else
				return ((obj.SubType & 0xF0) >> 4);
		}

		private static void SetSpeed(ObjectEntry obj, object value)
		{
			if ((obj.SubType & 0x80) == 0x80)
				obj.SubType = (byte)((obj.SubType & ~0xF0) | ((~(Math.Min(0x08, (int)value) - 1) & 0x0F) << 4));
			else
				obj.SubType = (byte)((obj.SubType & ~0xF0) | (Math.Min(0x07, (int)value) << 4));
		}

		private static object GetRotation(ObjectEntry obj)
		{
			return ((obj.SubType & 0x80) >> 7);
		}

		private static void SetRotation(ObjectEntry obj, object value)
		{
			if (((int)value==1) && (obj.SubType & 0x80) == 0)
				obj.SubType = (byte)((((~obj.SubType) & 0xF0) + 0x10) | (obj.SubType & 0x0F));
			else if ((((int)value==0) && (obj.SubType & 0x80) == 0x80))
				obj.SubType = (byte)(((((~obj.SubType) & 0xF0) + 0x10) | (obj.SubType & 0x0F)) & 0x7F);
		}
	}

	public enum ChainRotation
	{
		Clockwise,
		Counterclockwise
	}
}
