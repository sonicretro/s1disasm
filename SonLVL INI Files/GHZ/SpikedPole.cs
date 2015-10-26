using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.GHZ
{
	class SpikedPole : ObjectDefinition
	{
		private List<Sprite> imgs = new List<Sprite>();

		public override void Init(ObjectData data)
		{
			byte[] artfile = ObjectHelper.OpenArtFile("../artnem/GHZ Spiked Log.bin", CompressionType.Nemesis);
			for (int i = 0; i < 8; i++)
			{
				imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/Spiked Pole Helix.asm", i, 2));
			}
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new byte[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 }); }
		}

		public override string Name
		{
			get { return "Helix of spikes on a pole"; }
		}

		public override bool RememberState
		{
			get { return false; }
		}

		public override byte DefaultSubtype { get { return 0x10; } }

		public override string SubtypeName(byte subtype)
		{
			return Math.Min(0x16, (int)subtype) + " spikes";
		}

		public override Sprite Image
		{
			get { return imgs[0]; }
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return imgs[0];
		}

		public override Rectangle GetBounds(ObjectEntry obj, Point camera)
		{
			int spikeoffset = Math.Min(0x16, (int)obj.SubType)<<3;
			return new Rectangle(obj.X - (spikeoffset + 4) + imgs[0].X - camera.X, obj.Y + imgs[0].Y - camera.Y, spikeoffset*2, imgs[0].Height*2);
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			List<Sprite> sprs = new List<Sprite>();
			int spikeoffset = Math.Min(0x16, (int)obj.SubType)<<3;
			for (int i = 0; i < Math.Min(0x16, (int)obj.SubType); i++)
			{
				sprs.Add(new Sprite(imgs[i&7].Image, new Point(imgs[i&7].X - spikeoffset, imgs[i&7].Y)));
				spikeoffset -= 0x10;
			}
			Sprite spr = new Sprite(sprs.ToArray());
			spr.Offset = new Point(spr.X + obj.X, spr.Y + obj.Y);
			return spr;
		}

		private PropertySpec[] customProperties = new PropertySpec[] {
			new PropertySpec("Spikes", typeof(int), "Extended", null, null, GetSpikes, SetSpikes),
		};

		public override PropertySpec[] CustomProperties
		{
			get
			{
				return customProperties;
			}
		}

		private static object GetSpikes(ObjectEntry obj)
		{
			return Math.Min(0x16, (int)obj.SubType);
		}

		private static void SetSpikes(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)(Math.Max(1, (Math.Min(0x16, (int)value))));
		}
	}
}
