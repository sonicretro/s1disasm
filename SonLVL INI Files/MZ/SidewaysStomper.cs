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
				sprs.Add(new Sprite(imgs[0].Image, new Point(xoff + imgs[0].X, imgs[0].Y)));
				sprs.Add(new Sprite(imgs[1].Image, new Point(xoff - 0x1C + imgs[1].X, imgs[1].Y)));
				Sprite spr = new Sprite(sprs.ToArray());
				spr.Offset = new Point(spr.X, spr.Y);
				return spr;
			}
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			List<Sprite> sprs = new List<Sprite>();
			int xoff = 4;
			sprs.Add(new Sprite(imgs[0].Image, new Point(xoff + imgs[0].X, imgs[0].Y)));
			sprs.Add(new Sprite(imgs[1].Image, new Point(xoff - 0x1C + imgs[1].X, imgs[1].Y)));
			Sprite spr = new Sprite(sprs.ToArray());
			spr.Offset = new Point(spr.X, spr.Y);
			return spr;
		}

		public override Rectangle GetBounds(ObjectEntry obj, Point camera)
		{
			int[] poles = {0x38, 0xA0, 0x50};
			return new Rectangle(
				obj.X - camera.X + 4 - poles[obj.SubType] - 0x1C - (imgs[1].Width / 2),
				obj.Y - camera.Y - (imgs[0].Height/2),
				(imgs[1].Width / 2) + 0x1C + poles[obj.SubType] + 0x28 + (imgs[2].Image.Width / 2),
				imgs[0].Image.Height
			);
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			List<Sprite> sprs = new List<Sprite>();
			int globalxoff = 4;
			int secondaryxoff = 0;
			switch (obj.SubType)
			{
				default:
					secondaryxoff = -0x38;
					sprs.Add(new Sprite(imgs[3].Image, new Point(globalxoff + secondaryxoff + 0x34 + imgs[3].X, imgs[3].Y)));
					break;
				case 01:
					secondaryxoff = -0xA0;
					sprs.Add(new Sprite(imgs[5].Image, new Point(globalxoff + secondaryxoff + 0x34 + imgs[5].X, imgs[5].Y)));
					break;
				case 02:
					secondaryxoff = -0x50;
					sprs.Add(new Sprite(imgs[4].Image, new Point(globalxoff + secondaryxoff + 0x34 + imgs[4].X, imgs[4].Y)));
					break;
			}
			sprs.Add(new Sprite(imgs[2].Image, new Point(globalxoff + 0x28 + imgs[2].X, imgs[2].Y)));
			sprs.Add(new Sprite(imgs[1].Image, new Point(globalxoff + secondaryxoff - 0x1C + imgs[1].X, imgs[1].Y)));
			sprs.Add(new Sprite(imgs[0].Image, new Point(globalxoff + secondaryxoff + imgs[0].X, imgs[0].Y)));
			Sprite spr = new Sprite(sprs.ToArray());
			spr.Offset = new Point(spr.X + obj.X, spr.Y + obj.Y);
			return spr;
		}
	}
}
