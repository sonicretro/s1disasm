using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.Common
{
	public class Ring : ObjectDefinition
	{
		private Size[] Spacing = {
									 new Size(0x10, 0), // horizontal tight
									 new Size(0x18, 0), // horizontal normal
									 new Size(0x20, 0), // horizontal wide
									 new Size(0, 0x10), // vertical tight
									 new Size(0, 0x18), // vertical normal
									 new Size(0, 0x20), // vertical wide
									 new Size(0x10, 0x10), // diagonal
									 new Size(0x18, 0x18),
									 new Size(0x20, 0x20),
									 new Size(-0x10, 0x10),
									 new Size(-0x18, 0x18),
									 new Size(-0x20, 0x20),
									 new Size(0x10, 8),
									 new Size(0x18, 0x10),
									 new Size(-0x10, 8),
									 new Size(-0x18, 0x10)
								 };

		private Sprite img;

		public override void Init(ObjectData data)
		{
			byte[] artfile = ObjectHelper.OpenArtFile("../artnem/Rings.nem", CompressionType.Nemesis);
			img = ObjectHelper.MapASMToBmp(artfile, data.CustomProperties.GetValueOrDefault("revision", "0") == "1" ? "../_maps/Rings (JP1).asm" : "../_maps/Rings.asm", 0, 1);
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new List<byte>()); }
		}

		public override string Name
		{
			get { return "Ring"; }
		}

		public override bool RememberState
		{
			get { return true; }
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
			int count = Math.Min(6, obj.SubType & 7) + 1;
			Size space = Spacing[obj.SubType >> 4];
			Point loc = new Point();
			List<Sprite> sprs = new List<Sprite>();
			for (int i = 0; i < count; i++)
			{
				Sprite tmp = new Sprite(img);
				tmp.Offset(loc);
				sprs.Add(tmp);
				loc += space;
			}
			return new Sprite(sprs.ToArray());
		}

		private PropertySpec[] customProperties = new PropertySpec[] {
			new PropertySpec("Count", typeof(int), "Extended", null, null, GetCount, SetCount),
			new PropertySpec("Direction", typeof(int), "Extended", null, null, typeof(DirectionConverter), GetDirection, SetDirection)
		};

		public override PropertySpec[] CustomProperties
		{
			get
			{
				return customProperties;
			}
		}

		private static object GetCount(ObjectEntry obj)
		{
			return Math.Min(6, obj.SubType & 7) + 1;
		}

		private static void SetCount(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~7) | (Math.Min((int)value, 7) - 1));
		}

		private static object GetDirection(ObjectEntry obj)
		{
			return obj.SubType >> 4;
		}

		private static void SetDirection(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~0xF0) | (((int)value & 0xF) << 4));
		}
	}

	internal class DirectionConverter : TypeConverter
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

		private Dictionary<string, int> values = new Dictionary<string, int>()
		{
			{ "Right (Short)", 0 },
			{ "Right (Medium)", 1 },
			{ "Right (Far)", 2 },
			{ "Down (Short)", 3 },
			{ "Down (Medium)", 4 },
			{ "Down (Far)", 5 },
			{ "Down-Right (Short)", 6 },
			{ "Down-Right (Medium)", 7 },
			{ "Down-Right (Far)", 8 },
			{ "Down-Left (Short)", 9 },
			{ "Down-Left (Medium)", 10 },
			{ "Down-Left (Far)", 11 },
			{ "Down-Right-Right (Short)", 12 },
			{ "Down-Right-Right (Medium)", 13 },
			{ "Down-Left-Left (Short)", 14 },
			{ "Down-Left-Left (Medium)", 15 }
		};
	}
}
