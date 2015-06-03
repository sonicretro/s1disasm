using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.SBZ
{
	class Flamethrower : ObjectDefinition
	{
		private int[] labels = { 9, 20 };
		private List<Sprite> imgs = new List<Sprite>();

		public override void Init(ObjectData data)
		{
			byte[] artfile = ObjectHelper.OpenArtFile("../artnem/SBZ Flaming Pipe.bin", CompressionType.Nemesis);
			for (int i = 0; i < labels.Length; i++)
				imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/Flamethrower.asm", labels[i], 0));
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new List<byte>()); }
		}

		public override string Name
		{
			get { return "Flamethrower"; }
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
			get { return imgs[0]; }
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return imgs[0];
		}

		public override Rectangle GetBounds(ObjectEntry obj, Point camera)
		{
			Sprite img = new Sprite();
			if (obj.YFlip == true)
				img = imgs[1];
			else
				img = imgs[0];
			return new Rectangle(
				obj.X + img.Offset.X - camera.X,
				obj.Y + img.Offset.Y - camera.Y,
				img.Width,
				img.Height
			);
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			Sprite img = new Sprite();
			if (obj.YFlip == true)
				img = imgs[1];
			else
				img = imgs[0];
			Sprite spr = new Sprite(img.Image, new Point(img.X, img.Y));
			BitmapBits bits = new BitmapBits(spr.Image);
			bits.Flip(obj.XFlip, obj.YFlip);
			spr.Image = bits;
			spr.Offset = new Point(spr.X + obj.X, spr.Y + obj.Y);
			return spr;
		}
	}
}
