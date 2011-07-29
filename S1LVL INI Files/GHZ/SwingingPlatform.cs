using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL;

namespace S1ObjectDefinitions.GHZ
{
    class SwingingPlatform : SonicRetro.SonLVL.ObjectDefinition
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
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/GHZ Swinging Platform.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Swinging Platforms (GHZ).asm", 0, 2, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            BitmapBits im;
            for (int i = 0; i < labels.Length; i++)
            {
                im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Swinging Platforms (GHZ).asm", labels[i], i == 1 ? 1 : 2, out off);
                imgs.Add(im);
                offsets.Add(off);
                imgws.Add(im.Width);
                imghs.Add(im.Height);
            }
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 });
        }

        public override string Name()
        {
            return "Swinging Platform";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            return (subtype & 15) + " links";
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
                return img;
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, imgw, imgh * ((subtype & 15) + 2) - 8);
        }

        public override void Draw(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            int length = subtype & 15;
            BitmapBits bits = new BitmapBits(imgs[2]);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[2].X, loc.Y + offsets[2].Y));
            loc.Y += 16;
            bits = new BitmapBits(imgs[1]);
            for (int i = 0; i < length; i++)
            {
                bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[1].X, loc.Y + offsets[1].Y));
                loc.Y += 16;
            }
            loc.Y -= 8;
            bits = new BitmapBits(imgs[0]);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[0].X, loc.Y + offsets[0].Y));
        }
    }
}