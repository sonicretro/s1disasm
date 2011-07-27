using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.S2LVL;

namespace S1ObjectDefinitions.GHZ
{
    class WallBarrier : ObjectDefinition
    {
        private List<Point> offsets = new List<Point>();
        private List<BitmapBits> imgs = new List<BitmapBits>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/GHZ Edge Wall.bin", Compression.CompressionType.Nemesis);
            Point off;
            BitmapBits im;
            im = ObjectHelper.MapASMToBmp(artfile, "../_maps/GHZ Edge Walls.asm", 0, 2, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapASMToBmp(artfile, "../_maps/GHZ Edge Walls.asm", 1, 2, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapASMToBmp(artfile, "../_maps/GHZ Edge Walls.asm", 2, 2, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x01, 0x02, 0x10, 0x11, 0x12 });
        }

        public override string Name()
        {
            return "Wall Barrier";
        }

        public override bool RememberState()
        {
            return true;
        }

        public override string SubtypeName(byte subtype)
        {
            return ((EdgeType)(subtype & 0xF)).ToString();
        }

        public override string FullName(byte subtype)
        {
            return Name() + " - " + SubtypeName(subtype);
        }

        public override BitmapBits Image()
        {
            return imgs[0];
        }

        private int imgindex(byte SubType)
        {
            return SubType & 0x3;
        }

        public override BitmapBits Image(byte subtype)
        {
            return imgs[imgindex(subtype)];
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
                return typeof(WallBarrierS1ObjectEntry);
            }
        }
    }

    public class WallBarrierS1ObjectEntry : S1ObjectEntry
    {
        public WallBarrierS1ObjectEntry() : base() { }
        public WallBarrierS1ObjectEntry(byte[] file, int address) : base(file, address) { }

        public EdgeType Art
        {
            get
            {
                return (EdgeType)(SubType & 0xF);
            }
            set
            {
                SubType = (byte)((SubType & ~0xF) | (int)value);
            }
        }

        public bool Solid
        {
            get
            {
                return (SubType & 0x10) == 0x10;
            }
            set
            {
                SubType = (byte)((SubType & ~0x10) | (value ? 0x10 : 0));
            }
        }
    }

    public enum EdgeType
    {
        Shadow,
        Light,
        Dark
    }
}