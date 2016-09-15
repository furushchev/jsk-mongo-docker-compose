i = 0;
module.exports = function(msg) {
    if(i++%100==0) {
	console.log(i + ' message processed');
    }
    return msg;
};
