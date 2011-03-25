using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.S2LVL;

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

        private Point offset;
        private Bitmap img;
        private int imgw, imgh;
        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/Rings.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Rings.asm", "@front", 1, out offset);
            imgw = img.Width;
            imgh = img.Height;
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new List<byte>());
        }

        public override string Name()
        {
            return "Ring";
        }

        public override bool RememberState()
        {
            return true;
        }

        public override string SubtypeName(byte subtype)
        {
            return string.Empty;
        }

        public override string FullName(byte subtype)
        {
            return Name();
        }

        public override Bitmap Image()
        {
            return img;
        }

        public override Bitmap Image(byte subtype)
        {
            return img;
        }

        public override void Draw(Graphics gfx, Point loc, byte subtype, bool XFlip, bool YFlip)
        {
            int count = Math.Min(6, subtype & 7) + 1;
            Size space = Spacing[subtype >> 4];
            for (int i = 0; i < count; i++)
            {
                gfx.DrawImage(img, loc.X + offset.X, loc.Y + offset.Y, imgw, imgh);
                loc += space;
            }
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            int count = Math.Min(6, subtype & 7);
            Size space = Spacing[subtype >> 4];
            return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, (space.Width * count) + imgw, (space.Height * count) + imgh);
        }

        public override Type ObjectType
        {
            get
            {
                return typeof(RingS1ObjectEntry);
            }
        }

        public override void PaletteChanged(System.Drawing.Imaging.ColorPalette pal)
        {
            img.Palette = pal;
        }
    }

    public class RingS1ObjectEntry : S1ObjectEntry
    {
        public RingS1ObjectEntry() : base() { }
        public RingS1ObjectEntry(byte[] file, int address) : base(file, address) { }

        public int Count
        {
            get
            {
                return Math.Min(6, SubType & 7) + 1;
            }
            set
            {
                SubType = (byte)((SubType & ~7) | (Math.Min(value, 7) - 1));
            }
        }

        public int Direction
        {
            get
            {
                return SubType >> 4;
            }
            set
            {
                SubType = (byte)((SubType & ~0xF0) | ((value & 0xF) << 4));
            }
        }
    }
}