var OZUSLClientSession = function(){
	this.strServerURL = ""
	this.setServerURL = function(url){
		strServerURL = url;
	};
	this.strServerIP = ""
	this.strServerIP = function(ip){
		strServerIP = iprl;
	};
	this.createSecureOutputStream = function(bytes, params){
		var dst = new ByteArray();
		var nCount = 0;
		var strParamName;
		for(strParamName in params){
			nCount++;
		}
		dst.writeInt(nCount);
		for(strParamName in params){
			var strParamValue = params[strParamName];
			this.writeString(dst, strParamName);
			this.writeString(dst, strParamValue);
		}
		dst.writeBytes(bytes, 0, bytes.length);
		dst.position = 0;
		return dst;
	};
	this.createSecureInputStream = function(bytes, params){
   	var size = bytes.readInt();
   	for(var i=0; i<size; i++){
			var strParamName = this.readString(bytes);
			var strParamValue = this.readString(bytes);
			params[strParamName] = strParamValue;
		}
		var dst = new ByteArray();
		dst.writeBytes(bytes, bytes.position, bytes.length - bytes.position);
		dst.position = 0;
		return dst;
	};
	this.writeString = function(bytes, str)
	{
		var i;
		var strlen = str.length;
		
		bytes.writeInt(strlen);
		var v;
		
		for (i=0; i<strlen; i++)
		{
			v = str.charCodeAt(i);
			bytes.writeByte((v >>> 8) & 0xFF);
			bytes.writeByte((v >>> 0) & 0xFF);
		}
	};
	this.readString = function(bytes)
	{
		var strlen;
		var ch1, ch2;

		strlen = bytes.readInt();

		if (strlen == -1)
		{
			return "<NULL>";
		}
		else if (strlen < -1)
		{
			throw new Error("A malformed string has been read in a data input stream.");
		}
		
		var str = "";
		var position = bytes.position;

		for (var i = 0; i<strlen; i++)
		{
			ch1 = bytes[position+i*2];
			ch2 = bytes[position+i*2+1];
			
			if ((ch1 | ch2) < 0)
			{
				throw new Error("A malformed string has been read in a data input stream.");
			}
			
			str += String.fromCharCode((ch1 << 8) + (ch2 << 0));
		}
		bytes.position += strlen*2; 
		return str;
	};
};

