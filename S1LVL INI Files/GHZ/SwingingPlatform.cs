using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using Extensions;
using SonicRetro.S2LVL;

namespace S1ObjectDefinitions.GHZ
{
    class SwingingPlatform : SonicRetro.S2LVL.ObjectDefinition
    {
        private string[] labels = { "@block", "@chain", "@anchor" };
        private Point offset;
        private Bitmap img;
        private int imgw, imgh;
        private List<Point> offsets = new List<Point>();
        private List<Bitmap> imgs = new List<Bitmap>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/GHZ Swinging Platform.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Swinging Platforms (GHZ).asm", "@block", 2, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            Bitmap im;
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
            int length = subtype & 15;
            gfx.DrawImage(imgs[2], loc.X + offsets[2].X, loc.Y + offsets[2].Y, imgws[2], imghs[2]);
            loc.Y += 16;
            for (int i = 0; i < length; i++)
            {
                gfx.DrawImage(imgs[1], loc.X + offsets[1].X, loc.Y + offsets[1].Y, imgws[1], imghs[1]);
                loc.Y += 16;
            }
            loc.Y -= 8;
            gfx.DrawImage(imgs[0], loc.X + offsets[0].X, loc.Y + offsets[0].Y, imgws[0], imghs[0]);
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, imgw, imgh * ((subtype & 15) + 2) - 8);
        }

        public override void PaletteChanged(System.Drawing.Imaging.ColorPalette pal)
        {
            img.Palette = pal;
            foreach (Bitmap item in imgs)
            {
                item.Palette = pal;
            }
        }
    }
}