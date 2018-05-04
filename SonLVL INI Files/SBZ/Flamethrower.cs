using System.Collections.Generic;
using System.Collections.ObjectModel;
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

		public override Sprite GetSprite(ObjectEntry obj)
		{
			Sprite img = new Sprite(obj.YFlip ? imgs[1] : imgs[0]);
			img.Flip(obj.XFlip, obj.YFlip);
			return img;
		}
	}
}
