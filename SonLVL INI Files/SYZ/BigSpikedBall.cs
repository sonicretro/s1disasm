using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.SYZ
{
	class BigSpikedBall : ObjectDefinition
	{
		private Sprite img;

		public override void Init(ObjectData data)
		{
			img = (ObjectHelper.MapASMToBmp(ObjectHelper.OpenArtFile("../artnem/SYZ Large Spikeball.bin", CompressionType.Nemesis), "../_maps/Big Spiked Ball.asm", 0, 0));
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new List<byte>()); }
		}

		public override string Name
		{
			get { return "Big Spiked Ball"; }
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
			int yoff = 0;
			if ((obj.SubType & 0x0F) == (int)SpikeballMovement.Circular)
			{
				if (obj.YFlip == true)
					yoff = -0x50;
				else
					yoff = 0x50;
			}
			Sprite tmp = new Sprite(img);
			tmp.Offset(0, yoff);
			return tmp;
		}

		private static readonly PropertySpec[] customProperties = new PropertySpec[] {
			new PropertySpec("Movement", typeof(SpikeballMovement), "Extended", null, null, GetMovement, SetMovement),
			new PropertySpec("Speed (Circular Only)", typeof(int), "Speed", null, null, GetSpeed, SetSpeed),
			new PropertySpec("Rotation (Circular Only)", typeof(SpikeballRotation), "Extended", null, null, GetRotation, SetRotation)
		};

		public override PropertySpec[] CustomProperties
		{
			get { return customProperties; }
		}

		public static object GetMovement(ObjectEntry obj)
		{
			return (SpikeballMovement)(obj.SubType & 0x0F);
		}

		public static void SetMovement(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~0x0F) | (int)value);
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

	public enum SpikeballMovement
	{
		Stationary,
		Horizontal,
		Vertical,
		Circular
	}

	public enum SpikeballRotation
	{
		Clockwise,
		Counterclockwise
	}
}
