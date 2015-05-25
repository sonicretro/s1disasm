using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.LZ
{
	class Spikeball : ObjectDefinition
	{
		private int[] labels = { 0, 1, 2 };
		private Sprite img;
		private List<Sprite> imgs = new List<Sprite>();

		public override void Init(ObjectData data)
		{
			byte[] artfile = ObjectHelper.OpenArtFile("../artnem/LZ Spiked Ball & Chain.bin", CompressionType.Nemesis);
			img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Spiked Ball and Chain (LZ).asm", 1, 0);
			for (int i = 0; i < labels.Length; i++)
				imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/Spiked Ball and Chain (LZ).asm", labels[i], 0));
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new List<byte>()); }
		}

		public override string Name
		{
			get { return "Spikeball on Chain"; }
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

		public override Rectangle GetBounds(ObjectEntry obj, Point camera)
		{
			if ((obj.SubType & 0x0F) != 0)
				return new Rectangle(obj.X + imgs[1].Offset.X - camera.X, obj.Y + imgs[2].Offset.Y - camera.Y + imgs[2].Height - (imgs[2].Image.Height + (imgs[0].Image.Height * ((obj.SubType & 0x0F)-1)) + imgs[1].Image.Height - (imgs[1].Image.Height / 4)), imgs[1].Image.Width, imgs[2].Image.Height + (imgs[0].Image.Height * ((obj.SubType & 0x0F) - 1)) + imgs[1].Image.Height - (imgs[1].Image.Height / 4));
			else
				return new Rectangle(obj.X + imgs[1].Offset.X - camera.X, obj.Y + imgs[1].Offset.Y - camera.Y, imgs[1].Image.Width, imgs[1].Image.Height);
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			int length = (obj.SubType & 0x0F) - 1;
			List<Sprite> sprs = new List<Sprite>();
			int yoff = 0;
			if (length != -1)
			{
				sprs.Add(imgs[2]);
				yoff -= 16;
			}
			for (int i = 0; i < length; i++)
			{
				sprs.Add(new Sprite(imgs[0].Image, new Point(imgs[0].X, yoff + imgs[0].Y)));
				yoff -= 16;
			}
			sprs.Add(new Sprite(imgs[1].Image, new Point(imgs[1].X, yoff + imgs[1].Y)));
			Sprite spr = new Sprite(sprs.ToArray());
			spr.Offset = new Point(spr.X + obj.X, spr.Y + obj.Y);
			return spr;
		}

		private PropertySpec[] customProperties = new PropertySpec[] {
			new PropertySpec("Chainlinks", typeof(int), "Extended", null, null, GetChainlinks, SetChainlinks),
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
			return obj.SubType & 0x07;
		}

		private static void SetChainlinks(ObjectEntry obj, object value)
		{
			value = Math.Max(0, (Math.Min(0x07, (int)value)));
			obj.SubType = (byte)((obj.SubType & ~0x07) | (int)value);
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
