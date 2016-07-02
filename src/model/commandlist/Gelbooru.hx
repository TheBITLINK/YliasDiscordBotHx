package model.commandlist;

import utils.DiscordUtils;
import translations.LangCenter;
import discordhx.message.Message;

class Gelbooru implements ICommandDefinition {
    public var paramsUsage = '*(tag 1)* *(tag 2)* *(tag n)*';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.gelbooru.description');
    }

    public function process(args: Array<String>): Void {
        var searchEngine = new MangaPicture(_context, {
            secured: false,
            host: 'gelbooru.com',
            limitKey: 'limit',
            tagsKey: 'tags',
            tagsKeySeparator: ',',
            pageKey: 'pid',
            pathToPosts: '/index.php?page=dapi&s=post&q=index',
            isJson: false,
            postDataInAttributes: true,
            nbPostsField: 'count',
            postsField: 'posts',
            postField: 'post',
            tagsField: 'tags',
            fileUrlField: 'file_url',
            ratingField: 'rating',
            tagsSeparator: ' '
        });

        searchEngine.searchPicture(args);
    }
}
