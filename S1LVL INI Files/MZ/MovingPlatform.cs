using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using Extensions;
using SonicRetro.S2LVL;

namespace S1ObjectDefinitions.MZ
{
    class MovingPlatform : ObjectDefinition
    {
		private string[] labels = { "@wide", "@sloped", "@narrow" };
        private List<Point> offsets = new List<Point>();
        private List<BitmapBits> imgs = new List<BitmapBits>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.LevelArt;
            Point off;
            BitmapBits im;
			im = ObjectHelper.MapASMToBmp(artfile, "../_maps/MZ Large Grassy Platforms.asm", "@wide", 2, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
			im = ObjectHelper.MapASMToBmp(artfile, "../_maps/MZ Large Grassy Platforms.asm", "@sloped", 2, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
			im = ObjectHelper.MapASMToBmp(artfile, "../_maps/MZ Large Grassy Platforms.asm", "@narrow", 2, out off);
			imgs.Add(im);
			offsets.Add(off);
			imgws.Add(im.Width);
			imghs.Add(im.Height);
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

        public override string FullName(byte subtype)
        {
            return Name() + " - " + SubtypeName(subtype);
        }

		public override BitmapBits Image()
		{
			return imgs[0];
		}

		public override BitmapBits Image(byte subtype)
		{
			if (subtype < labels.Length)
				return imgs[subtype];
			else
				return imgs[0];
		}

        private int imgindex(byte SubType)
        {
			return 0;
        }

		public override Rectangle Bounds(Point loc, byte subtype)
		{
			return new Rectangle(loc.X + offsets[imgindex(subtype)].X, loc.Y + offsets[imgindex(subtype)].Y, imgws[imgindex(subtype)], imghs[imgindex(subtype)]);
		}

        public override void Draw(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            BitmapBits bits = new BitmapBits(imgs[imgindex(subtype)]);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[imgindex(subtype)].X, loc.Y + offsets[imgindex(subtype)].Y));
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
