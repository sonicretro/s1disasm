using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.S2LVL;

namespace S1ObjectDefinitions.Common
{
    class Monitor : SonicRetro.S2LVL.ObjectDefinition
    {
        private int[] labels = { 1, 3, 4, 5, 6, 7, 8, 9, 10, 11 };
        private Point offset;
        private BitmapBits img;
        private int imgw, imgh;
        private List<Point> offsets = new List<Point>();
        private List<BitmapBits> imgs = new List<BitmapBits>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/Monitors.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Monitor.asm", 0, 0, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            BitmapBits im;
            for (int i = 0; i < 10; i++)
            {
                im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Monitor.asm", labels[i], 0, out off);
                imgs.Add(im);
                offsets.Add(off);
                imgws.Add(im.Width);
                imghs.Add(im.Height);
            }
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 });
        }

        public override string Name()
        {
            return "Monitor";
        }

        public override bool RememberState()
        {
            return true;
        }

        public override string SubtypeName(byte subtype)
        {
            switch (subtype)
            {
                case 0:
                    return "Static";
                case 1:
                    return "Eggman";
                case 2:
                    return "Sonic";
                case 3:
                    return "Shoes";
                case 4:
                    return "Shield";
                case 5:
                    return "Invincibility";
                case 6:
                    return "Rings";
                case 7:
                    return "S";
                case 8:
                    return "Goggles";
                case 9:
                    return "Broken";
                default:
                    return string.Empty;
            }
        }

        public override string FullName(byte subtype)
        {
            switch (subtype)
            {
                case 0:
                    return "Static Monitor";
                case 1:
                    return "Eggman Monitor";
                case 2:
                    return "Sonic Monitor";
                case 3:
                    return "Shoes Monitor";
                case 4:
                    return "Shield Monitor";
                case 5:
                    return "Invincibility Monitor";
                case 6:
                    return "Rings Monitor";
                case 7:
                    return "S Monitor";
                case 8:
                    return "Goggles Monitor";
                case 9:
                    return "Broken Monitor";
                default:
                    return "Monitor";
            }
        }

        public override BitmapBits Image()
        {
            return img;
        }

        public override BitmapBits Image(byte subtype)
        {
            if (subtype <= 9)
                return imgs[subtype];
            else
                return img;
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            if (subtype <= 9)
                return new Rectangle(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, imgws[subtype], imghs[subtype]);
            else
                return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, imgw, imgh);
        }

        public override void Draw(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            if (subtype > 9) subtype = 0;
            BitmapBits bits = new BitmapBits(imgs[subtype]);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y));
        }
    }
}