using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL;

namespace S1ObjectDefinitions.Common
{
    class EggPrison : SonicRetro.SonLVL.ObjectDefinition
    {
        private Point offset;
        private BitmapBits img;
        private int imgw, imgh;
        private List<Point> offsets = new List<Point>();
        private List<BitmapBits> imgs = new List<BitmapBits>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/Prison Capsule.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Prison Capsule.asm", 0, 0, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            BitmapBits im;
            for (int i = 0; i < 2; i++)
            {
                im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Prison Capsule.asm", i, 0, out off);
                imgs.Add(im);
                offsets.Add(off);
                imgws.Add(im.Width);
                imghs.Add(im.Height);
            }
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0, 1 });
        }

        public override string Name()
        {
            return "Egg Prison";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            switch (subtype)
            {
                case 0:
                    return "Capsule";
                case 1:
                    return "Button";
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
            if (subtype < 2)
                return imgs[subtype];
            else
                return img;
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            if (subtype < 2)
                return new Rectangle(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, imgws[subtype], imghs[subtype]);
            else
                return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, imgw, imgh);
        }

        public override void Draw(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            if (subtype > 2) subtype = 0;
            BitmapBits bits = new BitmapBits(imgs[subtype]);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y));
        }
    }
}