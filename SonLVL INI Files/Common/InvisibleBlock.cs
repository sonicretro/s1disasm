using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.Common
{
	class InvisibleBlock : ObjectDefinition
	{
		private Sprite img;

		public override void Init(ObjectData data)
		{
			byte[] artfile = ObjectHelper.OpenArtFile("../artnem/Monitors.bin", CompressionType.Nemesis);
			img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Invisible Barriers.asm", 0, 0);
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new byte[] { 0 }); }
		}

		public override string Name
		{
			get { return "Invisible solid block"; }
		}

		public override bool RememberState
		{
			get { return false; }
		}

		public override string SubtypeName(byte subtype)
		{
			return ((subtype >> 4) + 1) + "x" + ((subtype & 0xF) + 1) + " blocks";
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
			int w = ((obj.SubType >> 4) + 1) * 16;
			int h = ((obj.SubType & 0xF) + 1) * 16;
			BitmapBits bmp = new BitmapBits(w, h);
			bmp.DrawRectangle(0x1C, 0, 0, w - 1, h - 1);
			return new Sprite(new Sprite(bmp, new Point(-(w / 2), -(h / 2))), img);
		}

		public override bool Debug { get { return true; } }

		private PropertySpec[] customProperties = new PropertySpec[] {
			new PropertySpec("Width", typeof(int), "Extended", null, null, GetWidth, SetWidth),
			new PropertySpec("Height", typeof(int), "Extended", null, null, GetHeight, SetHeight)
		};

		public override PropertySpec[] CustomProperties
		{
			get
			{
				return customProperties;
			}
		}

		private static object GetWidth(ObjectEntry obj)
		{
			return (obj.SubType & 0xF0) >> 4;
		}

		private static void SetWidth(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((Math.Min((int)value, 0xF) << 4) | (obj.SubType & 0xF));
		}

		private static object GetHeight(ObjectEntry obj)
		{
			return obj.SubType & 0xF;
		}

		private static void SetHeight(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)(Math.Min((int)value, 0xF) | (obj.SubType & 0xF0));
		}
	}
}
