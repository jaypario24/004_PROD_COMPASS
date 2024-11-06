public class GetObjectAPIName {
// This class is used to pass input into the Invocable Method.
public class RecordIdInput {
@InvocableVariable
public Id recordId;
}

// This class is used to get output from the Invocable Method.
public class ObjectTypeOutput {
@InvocableVariable
public String objectApiName;
}

@InvocableMethod(label='Get Object API Name' description='Returns the object API name based on record ID')
public static List<objecttypeoutput> getObjectAPIName(List<recordidinput> inputs) {
List<objecttypeoutput> outputs = new List<objecttypeoutput>();

for (RecordIdInput input : inputs) {
ObjectTypeOutput output = new ObjectTypeOutput();
output.objectApiName = input.recordId.getSObjectType().getDescribe().getName();
outputs.add(output);
}

return outputs;
}
}