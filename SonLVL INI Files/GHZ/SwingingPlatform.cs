using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;
using System;

namespace S1ObjectDefinitions.GHZ
{
    class SwingingPlatform : ObjectDefinition
    {
        private int[] labels = { 0, 1, 2 };
        private Sprite img;
        private List<Sprite> imgs = new List<Sprite>();

        public override void Init(ObjectData data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/GHZ Swinging Platform.bin", CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Swinging Platforms (GHZ).asm", 0, 2);
            for (int i = 0; i < labels.Length; i++)
                imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/Swinging Platforms (GHZ).asm", labels[i], i == 1 ? 1 : 2));
        }

        public override ReadOnlyCollection<byte> Subtypes
        {
            get { return new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }); }
        }

        public override string Name
        {
            get { return "Swinging Platform"; }
        }

        public override bool RememberState
        {
            get { return false; }
        }

        public override string SubtypeName(byte subtype)
        {
            return (subtype & 15) + " links";
        }

        public override Sprite Image
        {
            get { return img; }
        }

        public override Sprite SubtypeImage(byte subtype)
        {
            return img;
        }

        public override Rectangle GetBounds(ObjectEntry obj, Point camera)
        {
            return new Rectangle(obj.X + img.Offset.X - camera.X, obj.Y + img.Offset.Y - camera.Y, img.Image.Width, img.Image.Height * ((obj.SubType & 15) + 2) - 8);
        }

        public override Sprite GetSprite(ObjectEntry obj)
        {
            int length = obj.SubType & 15;
            List<Sprite> sprs = new List<Sprite>();
            sprs.Add(imgs[2]);
            int yoff = 16;
            for (int i = 0; i < length; i++)
            {
                sprs.Add(new Sprite(imgs[1].Image, new Point(imgs[1].X, yoff + imgs[1].Y)));
                yoff += 16;
            }
            yoff -= 8;
            sprs.Add(new Sprite(imgs[0].Image, new Point(imgs[0].X, yoff + imgs[0].Y)));
            Sprite spr = new Sprite(sprs.ToArray());
            spr.Offset = new Point(spr.X + obj.X, spr.Y + obj.Y);
            return spr;
        }
    }
}