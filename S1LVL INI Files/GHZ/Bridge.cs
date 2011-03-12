using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using Extensions;
using S2LVL;

namespace S1ObjectDefinitions.GHZ
{
    class Bridge : ObjectDefinition
    {
        private Point offset;
        private Bitmap img;
        private int imgw, imgh;

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/GHZ Bridge.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Bridge.asm", "M_Bri_Log", 2, out offset);
            imgw = img.Width;
            imgh = img.Height;
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 8, 10, 12, 14, 16 });
        }

        public override string Name()
        {
            return "Bridge";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            return (subtype & 0x1F) + " logs";
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
            int st = Bounds(loc, subtype).X;
            for (int i = 0; i < (subtype & 0x1F); i++)
            {
                gfx.DrawImageFlipped(img, st + (i * imgw), loc.Y + offset.Y, false, false);
            }
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            int w = (subtype & 0x1F) * imgw;
            return new Rectangle(loc.X - (w / 2) + offset.X, loc.Y + offset.Y, w, imgh);
        }

        public override void PaletteChanged(System.Drawing.Imaging.ColorPalette pal)
        {
            img.Palette = pal;
        }
    }
}
