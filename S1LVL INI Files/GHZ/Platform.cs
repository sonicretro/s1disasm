using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using Extensions;
using SonicRetro.S2LVL;

namespace S1ObjectDefinitions.GHZ
{
    class Platform : ObjectDefinition
    {
        private List<Point> offsets = new List<Point>();
        private List<Bitmap> imgs = new List<Bitmap>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.LevelArt;
            Point off;
            Bitmap im;
            im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Platforms (GHZ).asm", "@small", 2, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Platforms (GHZ).asm", "@large", 2, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C });
        }

        public override string Name()
        {
            return "Platform";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            return ((PlatformMovement)(subtype & 0xF)).ToString();
        }

        public override string FullName(byte subtype)
        {
            return Name() + " - " + SubtypeName(subtype);
        }

        public override Bitmap Image()
        {
            return imgs[0];
        }

        private int imgindex(byte SubType)
        {
            switch ((PlatformMovement)(SubType & 0xF))
            {
                case PlatformMovement.Large:
                    return 1;
                default:
                    return 0;
            }
        }

        public override Bitmap Image(byte subtype)
        {
            return imgs[imgindex(subtype)];
        }

        public override void Draw(Graphics gfx, Point loc, byte subtype, bool XFlip, bool YFlip)
        {
            gfx.DrawImageFlipped(imgs[imgindex(subtype)], loc.X + offsets[imgindex(subtype)].X, loc.Y + offsets[imgindex(subtype)].Y, XFlip, YFlip);
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            return new Rectangle(loc.X + offsets[imgindex(subtype)].X, loc.Y + offsets[imgindex(subtype)].Y, imgws[imgindex(subtype)], imghs[imgindex(subtype)]);
        }

        public override void DrawExport(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            BitmapBits bits = new BitmapBits(imgs[imgindex(subtype)]);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[imgindex(subtype)].X, loc.Y + offsets[imgindex(subtype)].Y));
        }

        public override Type ObjectType
        {
            get
            {
                return typeof(PlatformS1ObjectEntry);
            }
        }

        public override void PaletteChanged(System.Drawing.Imaging.ColorPalette pal)
        {
            foreach (Bitmap item in imgs)
            {
                item.Palette = pal;
            }
        }
    }

    public class PlatformS1ObjectEntry : S1ObjectEntry
    {
        public PlatformS1ObjectEntry() : base() { }
        public PlatformS1ObjectEntry(byte[] file, int address) : base(file, address) { }

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
