using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using Extensions;
using SonicRetro.S2LVL;

namespace S1ObjectDefinitions.GHZ
{
    class Newtron : SonicRetro.S2LVL.ObjectDefinition
    {
        private string[] labels = { "M_Newt_Drop1", "M_Newt_Norm" };
        private Point offset;
        private Bitmap img;
        private int imgw, imgh;
        private List<Point> offsets = new List<Point>();
        private List<Bitmap> imgs = new List<Bitmap>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/Enemy Newtron.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Newtron.asm", "M_Newt_Drop1", 0, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            Bitmap im;
            for (int i = 0; i < labels.Length; i++)
            {
                im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Newtron.asm", labels[i], i, out off);
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
            return "Newtron";
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
                    return "Flies along the ground";
                case 1:
                    return "Fires missile, then disappears";
                default:
                    return string.Empty;
            }
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
            if (subtype < labels.Length)
                return imgs[subtype];
            else
                return img;
        }

        public override void Draw(Graphics gfx, Point loc, byte subtype, bool XFlip, bool YFlip)
        {
            if (subtype < labels.Length)
                gfx.DrawImageFlipped(imgs[subtype], loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, XFlip, YFlip);
            else
                gfx.DrawImageFlipped(img, loc.X + offset.X, loc.Y + offset.Y, XFlip, YFlip);
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            if (subtype < labels.Length)
                return new Rectangle(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, imgws[subtype], imghs[subtype]);
            else
                return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, imgw, imgh);
        }

        public override void DrawExport(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            if (subtype > labels.Length) subtype = 0;
            BitmapBits bits = new BitmapBits(imgs[subtype]);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y));
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