using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.GHZ
{
	class Bridge : ObjectDefinition
	{
		private Sprite img;

		public override void Init(ObjectData data)
		{
			byte[] artfile = ObjectHelper.OpenArtFile("../artnem/GHZ Bridge.bin", CompressionType.Nemesis);
			img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Bridge.asm", 0, 2);
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new byte[] { 8, 10, 12, 14, 16 }); }
		}

		public override string Name
		{
			get { return "Bridge"; }
		}

		public override bool RememberState
		{
			get { return false; }
		}

		public override byte DefaultSubtype { get { return 8; } }

		public override string SubtypeName(byte subtype)
		{
			return (subtype & 0x1F) + " logs";
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
			int st = -(((obj.SubType & 0x1F) * img.Width) / 2);
			List<Sprite> sprs = new List<Sprite>();
			for (int i = 0; i < (obj.SubType & 0x1F); i++)
			{
				Sprite tmp = new Sprite(img);
				tmp.Offset(st + (i * img.Width), 0);
				sprs.Add(tmp);
			}
			return new Sprite(sprs.ToArray());
		}
	}
}
