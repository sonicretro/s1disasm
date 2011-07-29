using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL;

namespace S1ObjectDefinitions.Common
{
    class PointBonus : SonicRetro.SonLVL.ObjectDefinition
    {
        private int[] labels = { 0, 1, 2 };
        private Point offset;
        private BitmapBits img;
        private int imgw, imgh;
        private List<Point> offsets = new List<Point>();
        private List<BitmapBits> imgs = new List<BitmapBits>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/Hidden Bonuses.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Hidden Bonuses.asm", 2, 0, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            BitmapBits im;
            im = ObjectHelper.UnknownObject(out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            for (int i = 0; i < labels.Length; i++)
            {
                im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Hidden Bonuses.asm", labels[i], 0, out off);
                imgs.Add(im);
                offsets.Add(off);
                imgws.Add(im.Width);
                imghs.Add(im.Height);
            }
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 1, 2, 3 });
        }

        public override string Name()
        {
            return "Hidden point bonus";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            switch (subtype)
            {
                case 1:
                    return 10000.ToString("N0") + " points";
                case 2:
                    return 1000.ToString("N0") + " points";
                case 3:
                    return 100.ToString("N0") + " points";
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
            return img;
        }

        public override BitmapBits Image(byte subtype)
        {
            if (subtype < labels.Length + 1)
                return imgs[subtype];
            else
                return img;
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            if (subtype < labels.Length + 1)
                return new Rectangle(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, imgws[subtype], imghs[subtype]);
            else
                return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, imgw, imgh);
        }

        public override void Draw(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            if (subtype > labels.Length + 1) subtype = 0;
            if (subtype == 0 & !includeDebug) return;
            BitmapBits bits = new BitmapBits(imgs[subtype]);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y));
        }
    }
}