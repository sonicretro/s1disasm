using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.Common
{
    class EggPrison : ObjectDefinition
    {
        private Sprite img;
        private List<Sprite> imgs = new List<Sprite>();

        public override void Init(ObjectData data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/Prison Capsule.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Prison Capsule.asm", 0, 0);
            for (int i = 0; i < 2; i++)
                imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/Prison Capsule.asm", i, 0));
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

        public override BitmapBits Image()
        {
            return img.Image;
        }

        public override BitmapBits Image(byte subtype)
        {
            if (subtype < 2)
                return imgs[subtype].Image;
            else
                return img.Image;
        }

        public override Rectangle Bounds(ObjectEntry obj, Point camera)
        {
            if (obj.SubType < 2)
                return new Rectangle(obj.X + imgs[obj.SubType].X - camera.X, obj.Y + imgs[obj.SubType].Y - camera.Y, imgs[obj.SubType].Width, imgs[obj.SubType].Height);
            else
                return new Rectangle(obj.X + img.X - camera.X, obj.Y + img.Y - camera.Y, img.Width, img.Height);
        }

        public override Sprite GetSprite(ObjectEntry obj)
        {
            byte subtype = obj.SubType;
            if (subtype > 2) subtype = 0;
            BitmapBits bits = new BitmapBits(imgs[subtype].Image);
            bits.Flip(obj.XFlip, obj.YFlip);
            return new Sprite(bits, new Point(obj.X + imgs[subtype].Offset.X, obj.Y + imgs[subtype].Offset.Y));
        }
    }
}