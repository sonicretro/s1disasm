using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.SLZ
{
    class SwingingPlatform : ObjectDefinition
    {
        private int[] labels = { 0, 1, 2 };
        private Sprite img;
        private Sprite imgwreckingball;
        private List<Sprite> imgs = new List<Sprite>();

        public override void Init(ObjectData data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/GHZ Giant Ball.bin", CompressionType.Nemesis);
            imgwreckingball = ObjectHelper.MapASMToBmp(artfile, "../_maps/GHZ Ball.asm", 1, 2);
            artfile = ObjectHelper.OpenArtFile("../artnem/SLZ Swinging Platform.bin", CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Swinging Platforms (SLZ).asm", 0, 2);
            for (int i = 0; i < labels.Length; i++)
                imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/Swinging Platforms (SLZ).asm", labels[i], i == 1 ? 0 : 2));
        }

        public override ReadOnlyCollection<byte> Subtypes
        {
            get { return new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 }); }
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
            if ((subtype & 16) != 0)
                return (subtype & 15) + " links + wrecking ball";
            else
                return (subtype & 15) + " links";
        }

        public override Sprite Image
        {
            get { return img; }
        }

        public override Sprite SubtypeImage(byte subtype)
        {
            if ((subtype & 16) != 0)
                return imgwreckingball;
            else
                return img;
        }

        public override Rectangle GetBounds(ObjectEntry obj, Point camera)
        {
            if ((obj.SubType & 16) !=0)
                return new Rectangle(obj.X + imgwreckingball.Offset.X - camera.X, obj.Y + imgs[2].Offset.Y - camera.Y, imgwreckingball.Image.Width, imgs[2].Image.Height + (imgs[1].Image.Height * (obj.SubType & 15)) + imgwreckingball.Image.Height - (imgwreckingball.Image.Height / 2));
            else
                return new Rectangle(obj.X + imgs[0].Offset.X - camera.X, obj.Y + imgs[2].Offset.Y - camera.Y, imgs[0].Image.Width, imgs[2].Image.Height + (imgs[1].Image.Height * (obj.SubType & 15)) + ((imgs[0].Image.Height + (imgs[0].Bottom + imgs[0].Top)) / 2));
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
            if ((obj.SubType & 16) !=0)
                sprs.Add(new Sprite(imgwreckingball.Image, new Point(imgwreckingball.X, yoff + imgwreckingball.Y)));
            else
                sprs.Add(new Sprite(imgs[0].Image, new Point(imgs[0].X, yoff + imgs[0].Y)));
            Sprite spr = new Sprite(sprs.ToArray());
            spr.Offset = new Point(spr.X + obj.X, spr.Y + obj.Y);
            return spr;
        }

        private PropertySpec[] customProperties = new PropertySpec[] {
            new PropertySpec("Wrecking Ball", typeof(bool), "Extended", null, null, GetWreckingBall, SetWreckingBall)
        };

        public override PropertySpec[] CustomProperties
        {
            get
            {
                return customProperties;
            }
        }

        private static object GetWreckingBall(ObjectEntry obj)
        {
            return (obj.SubType & 16) != 0 ? true : false;
        }

        private static void SetWreckingBall(ObjectEntry obj, object value)
        {
            obj.SubType = (byte)((obj.SubType & ~16) | ((bool)value == true ? 16 : 0));
        }
    }
}