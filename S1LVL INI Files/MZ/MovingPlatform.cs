using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.MZ
{
    class MovingPlatform : ObjectDefinition
    {
		private int[] labels = { 0, 1, 2 };
        private List<Sprite> imgs = new List<Sprite>();

        public override void Init(ObjectData data)
        {
            byte[] artfile = ObjectHelper.LevelArt;
			imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/MZ Large Grassy Platforms.asm", 0, 2));
			imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/MZ Large Grassy Platforms.asm", "@sloped", 2));
			imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/MZ Large Grassy Platforms.asm", "@narrow", 2));
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x15, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29});
        }

        public override string Name()
        {
            return "Grass Platform";
        }

        public override bool RememberState()
        {
            return false;
        }

		public override string SubtypeName(byte subtype)
		{
			switch (subtype)
			{
				case 0x00:
					return "Large Oscillating";
				case 0x15:
					return "Sinking";
				case 0x20:
					return "Small Oscillating(Speed 0)";
				case 0x21:
					return "Small Oscillating(Speed 1)";
				case 0x22:
					return "Small Oscillating(Speed 2)";
				case 0x23:
					return "Small Oscillating(Speed 3)";
				case 0x24:
					return "Small Oscillating(Speed 4)";
				case 0x25:
					return "Small Oscillating(Speed 5)";
				case 0x26:
					return "Small Oscillating(Speed 6)";
				case 0x27:
					return "Small Oscillating(Speed 7)";
				case 0x28:
					return "Small Oscillating(Speed 8)";
				case 0x29:
					return "Small Oscillating(Speed 9)";
				default:
					return string.Empty;
			}
		}

		public override BitmapBits Image()
		{
			return imgs[0].Image;
		}

		public override BitmapBits Image(byte subtype)
		{
			if (subtype < labels.Length)
				return imgs[subtype].Image;
			else
				return imgs[0].Image;
		}

        private int imgindex(byte SubType)
        {
			return 0;
        }

		public override Rectangle Bounds(ObjectEntry obj, Point camera)
		{
			return new Rectangle(obj.X + imgs[imgindex(obj.SubType)].X - camera.X, obj.Y + imgs[imgindex(obj.SubType)].Y - camera.Y, imgs[imgindex(obj.SubType)].Width, imgs[imgindex(obj.SubType)].Height);
		}

        public override Sprite GetSprite(ObjectEntry obj)
        {
            BitmapBits bits = new BitmapBits(imgs[imgindex(obj.SubType)].Image);
            bits.Flip(obj.XFlip, obj.YFlip);
            return new Sprite(bits, new Point(obj.X + imgs[imgindex(obj.SubType)].Offset.X, obj.Y + imgs[imgindex(obj.SubType)].Offset.Y));
        }

		public override Type ObjectType
		{
			get
			{
				return typeof(MZPlatformS1ObjectEntry);
			}
		}


		public class MZPlatformS1ObjectEntry : S1ObjectEntry
		{
			public MZPlatformS1ObjectEntry() : base() { }
			public MZPlatformS1ObjectEntry(byte[] file, int address) : base(file, address) { }

			public PlatformMovement Movement
			{
				get
				{
					return (PlatformMovement)(SubType & 0xF);
				}
				set
				{
					SubType = (byte)((SubType & ~0xF) | (int)value);
				}
			}

			public byte SwitchID
			{
				get
				{
					return (byte)(SubType >> 4);
				}
				set
				{
					SubType = (byte)((SubType & ~0xF0) | (value << 4));
				}
			}
		}

		public enum PlatformMovement
		{
			Stationary,
			RightLeft,
			DownUp,
			FallStand,
			Fall,
			LeftRight,
			UpDown,
			SwitchUp,
			MoveUp,
			Stationary2,
			Large,
			DownUpSlow,
			UpDownSlow,
			Invalid1,
			Invalid2,
			Invalid3
		}
    }
}
