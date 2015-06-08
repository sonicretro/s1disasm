using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.Common
{
	class PathSwapper : ObjectDefinition
	{
		private Sprite img;
		private List<Sprite> imgs = new List<Sprite>();

		public override void Init(ObjectData data)
		{
			List<byte> tmpartfile = new List<byte>();
			tmpartfile.AddRange(ObjectHelper.OpenArtFile("Common/pathswapper-art.bin", CompressionType.Nemesis));
			byte[] mapfile = System.IO.File.ReadAllBytes("Common/pathswapper-map.bin");
			byte[] artfile1 = tmpartfile.ToArray();
			img = ObjectHelper.MapToBmp(artfile1, mapfile, 0, 0);
			Point off;
			BitmapBits im;
			Point pos;
			Size delta;
			for (int i = 0; i < 32; i++)
			{
				byte[] artfile = tmpartfile.GetRange(((i & 0x1C) << 5), 128).ToArray();
				BitmapBits tempim = ObjectHelper.MapToBmp(artfile, mapfile, (i & 4), 0).Image;
				if ((i & 4) != 0)
				{
					im = new BitmapBits(tempim.Width * (1 << (i & 3)), tempim.Height);
					delta = new Size(tempim.Width, 0);
				}
				else
				{
					im = new BitmapBits(tempim.Width, tempim.Height * (1 << (i & 3)));
					delta = new Size(0, tempim.Height);
				}

				pos = new Point(0, 0);
				off = new Point(-(im.Width / 2), -(im.Height / 2));
				for (int j = 0; j < (1 << (i & 3)); j++)
				{
					im.DrawBitmap(tempim, pos);
					pos = pos + delta;
				}
				imgs.Add(new Sprite(im, off));
			}
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7 }); }
		}

		public override string Name
		{
			get { return "Path Swapper"; }
		}

		public override bool RememberState
		{
			get { return false; }
		}

		public override string SubtypeName(byte subtype)
		{
			string result = (subtype & 4) == 4 ? "Horizontal" : "Vertical";
			return result;
		}

		public override Sprite Image
		{
			get { return img; }
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return imgs[subtype & 0x1F];
		}

		public override Rectangle GetBounds(ObjectEntry obj, Point camera)
		{
			return new Rectangle(obj.X + imgs[obj.SubType & 0x1F].X - camera.X, obj.Y + imgs[obj.SubType & 0x1F].Y - camera.Y, imgs[obj.SubType & 0x1F].Width, imgs[obj.SubType & 0x1F].Height);
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			Sprite spr = new Sprite(imgs[obj.SubType & 0x1F].Image, imgs[obj.SubType & 0x1F].Offset);
			spr.Offset = new Point(obj.X + spr.X, obj.Y + spr.Y);
			return spr;
		}

		public override bool Debug { get { return true; } }

		private PropertySpec[] customProperties = new PropertySpec[] {
			new PropertySpec("Priority only", typeof(bool), "Extended", null, null, (o) => o.XFlip, (o, v) => o.XFlip = (bool)v),
			new PropertySpec("Size", typeof(byte), "Extended", null, null, GetSize, SetSize),
			new PropertySpec("Direction", typeof(Direction), "Extended", null, null, GetDirection, SetDirection),
			new PropertySpec("Right/Down Path", typeof(int), "Extended", null, null, typeof(PathConverter), GetRDPath, SetRDPath),
			new PropertySpec("Left/Up Path", typeof(int), "Extended", null, null, typeof(PathConverter), GetLUPath, SetLUPath),
			new PropertySpec("Right/Down Priority", typeof(Priority), "Extended", null, null, GetRDPriority, SetRDPriority),
			new PropertySpec("Left/Up Priority", typeof(Priority), "Extended", null, null, GetLUPriority, SetLUPriority),
			new PropertySpec("Ground only", typeof(bool), "Extended", null, null, GetGroundOnly, SetGroundOnly)
		};

		public override PropertySpec[] CustomProperties
		{
			get
			{
				return customProperties;
			}
		}

		private static object GetSize(ObjectEntry obj)
		{
			return (byte)(obj.SubType & 3);
		}

		private static void SetSize(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~3) | ((byte)value & 3));
		}

		private static object GetDirection(ObjectEntry obj)
		{
			return (obj.SubType & 4) != 0 ? Direction.Horizontal : Direction.Vertical;
		}

		private static void SetDirection(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~4) | ((Direction)value == Direction.Horizontal ? 4 : 0));
		}

		private static object GetRDPath(ObjectEntry obj)
		{
			return (obj.SubType & 8) >> 3;
		}

		private static void SetRDPath(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~8) | ((int)value << 3));
		}

		private static object GetLUPath(ObjectEntry obj)
		{
			return (obj.SubType & 16) >> 4;
		}

		private static void SetLUPath(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~16) | ((int)value << 4));
		}

		private static object GetRDPriority(ObjectEntry obj)
		{
			return (obj.SubType & 32) != 0 ? Priority.High : Priority.Low;
		}

		private static void SetRDPriority(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~32) | ((Priority)value == Priority.High ? 32 : 0));
		}

		private static object GetLUPriority(ObjectEntry obj)
		{
			return (obj.SubType & 64) != 0 ? Priority.High : Priority.Low;
		}

		private static void SetLUPriority(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~64) | ((Priority)value == Priority.High ? 64 : 0));
		}

		private static object GetGroundOnly(ObjectEntry obj)
		{
			return (obj.SubType & 128) != 0 ? true : false;
		}

		private static void SetGroundOnly(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~128) | ((bool)value == true ? 128 : 0));
		}
	}

	internal class PathConverter : TypeConverter
	{
		public override bool CanConvertFrom(ITypeDescriptorContext context, Type sourceType)
		{
			if (sourceType == typeof(string))
				return true;
			return base.CanConvertFrom(context, sourceType);
		}

		public override bool CanConvertTo(ITypeDescriptorContext context, Type destinationType)
		{
			if (destinationType == typeof(int))
				return true;
			return base.CanConvertTo(context, destinationType);
		}

		public override object ConvertFrom(ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value)
		{
			if (value is string)
				return values[(string)value];
			return base.ConvertFrom(context, culture, value);
		}

		public override object ConvertTo(ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, Type destinationType)
		{
			if (destinationType == typeof(string) && value is int)
			{
				string result = null;
				foreach (KeyValuePair<string, int> item in values)
					if (item.Value.Equals(value))
						result = item.Key;
				if (result != null) return result;
				throw new KeyNotFoundException();
			}
			return base.ConvertTo(context, culture, value, destinationType);
		}

		public override StandardValuesCollection GetStandardValues(ITypeDescriptorContext context)
		{
			return new StandardValuesCollection(values.Keys);
		}

		public override bool GetStandardValuesSupported(ITypeDescriptorContext context)
		{
			return true;
		}

		private Dictionary<string, int> values = new Dictionary<string, int>() { { "Path 1", 0 }, { "Path 2", 1 } };
	}

	public enum Priority
	{
		Low,
		High
	}
}