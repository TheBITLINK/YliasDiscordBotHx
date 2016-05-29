package utils;

class Humanify {
    public static function getMultimediaContentDeliverySentence(): String {
        var imageDeliverySentences: Array<String> = [
            'utils.humanify.getimagedeliverysentence.1',
            'utils.humanify.getimagedeliverysentence.2',
            'utils.humanify.getimagedeliverysentence.3',
            'utils.humanify.getimagedeliverysentence.4',
            'utils.humanify.getimagedeliverysentence.5'
        ];

        return ArrayUtils.random(imageDeliverySentences);
    }

    public static function getChoiceDeliverySentence(): String {
        var choiceDeliverySentences: Array<String> = [
            'utils.humanify.getchoicedeliverysentence.1',
            'utils.humanify.getchoicedeliverysentence.2',
            'utils.humanify.getchoicedeliverysentence.3',
            'utils.humanify.getchoicedeliverysentence.4'
        ];

        return ArrayUtils.random(choiceDeliverySentences);
    }

    public static function getBooleanValue(str: String): Bool {
        var ret: Bool = null;
        var stringsThatMeanTrue: Array<String> = [
            'ye',
            'yee',
            'yes',
            'yeah',
            'yea',
            'ui',
            'oui',
            'ouip',
            'ouai',
            'ouais',
            'ouaip',
            'ya',
            'yep',
            'yup',
            'yip',
            'yay',
            '1',
            'true',
            'vrai'
        ];
        var stringsThatMeanFalse: Array<String> = [
            'no',
            'noo',
            'noes',
            'noe',
            'non',
            'na',
            'nu',
            'niu',
            'nyu',
            'nuu',
            'niuu',
            'nyuu',
            'nuuu',
            'niuuu',
            'nyuuu',
            'nan',
            'naan',
            'nope',
            'nop',
            'nay',
            '0',
            'false',
            'faux'
        ];

        if (stringsThatMeanTrue.indexOf(str) > -1) {
            ret = true;
        } else if (stringsThatMeanFalse.indexOf(str) > -1) {
            ret = false;
        }

        return ret;
    }
}
