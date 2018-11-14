using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.MZ
{
	class SidewaysStomper : ObjectDefinition
	{
		private int[] labels = { 0, 1, 2, 5, 6, 8 };
		private List<Sprite> imgs = new List<Sprite>();

		public override void Init(ObjectData data)
		{
			byte[] blocks = ObjectHelper.OpenArtFile("../artnem/MZ Metal Blocks.bin", CompressionType.Nemesis);
			byte[] padding = new byte[0x4360-blocks.Length];
			byte[] spikes = ObjectHelper.OpenArtFile("../artnem/Spikes.bin", CompressionType.Nemesis);
			List<byte> tmpartfile = new List<byte>();
			tmpartfile.AddRange(blocks);
			tmpartfile.AddRange(padding);
			tmpartfile.AddRange(spikes);
			byte[] artfile = tmpartfile.ToArray();
			for (int i = 0; i < labels.Length; i++)
				imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/Sideways Stomper.asm", labels[i], 0));
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2 }); }
		}

		public override string Name
		{
			get { return "Sideways Stomper"; }
		}

		public override bool RememberState
		{
			get { return false; }
		}

		public override string SubtypeName(byte subtype)
		{
			switch (subtype)
			{
				case 0:
					return "Short";
				case 1:
					return "Long";
				case 2:
					return "Medium";
				default:
					return string.Empty;
			}
		}

		public override Sprite Image
		{
			get
			{
				List<Sprite> sprs = new List<Sprite>();
				int xoff = 4;
				Sprite tmp = new Sprite(imgs[0]);
				tmp.Offset(xoff, 0);
				sprs.Add(tmp);
				tmp = new Sprite(imgs[1]);
				tmp.Offset(xoff - 0x1C, 0);
				sprs.Add(tmp);
				return new Sprite(sprs.ToArray());
			}
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return Image;
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			List<Sprite> sprs = new List<Sprite>();
			int globalxoff = 4;
			int secondaryxoff = 0;
			Sprite tmp;
			switch (obj.SubType)
			{
				default:
					secondaryxoff = -0x38;
					tmp = new Sprite(imgs[3]);
					break;
				case 01:
					secondaryxoff = -0xA0;
					tmp = new Sprite(imgs[5]);
					break;
				case 02:
					secondaryxoff = -0x50;
					tmp = new Sprite(imgs[4]);
					break;
			}
			tmp.Offset(globalxoff + secondaryxoff + 0x34, 0);
			sprs.Add(tmp);
			tmp = new Sprite(imgs[2]);
			tmp.Offset(globalxoff + 0x28, 0);
			sprs.Add(tmp);
			tmp = new Sprite(imgs[1]);
			tmp.Offset(globalxoff + secondaryxoff - 0x1C, 0);
			sprs.Add(tmp);
			tmp = new Sprite(imgs[0]);
			tmp.Offset(globalxoff + secondaryxoff, 0);
			sprs.Add(tmp);
			return new Sprite(sprs.ToArray());
		}
	}
}
