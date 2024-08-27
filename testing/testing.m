function Class=testing(Trainfea,Target,Testfea) 
load Trainfea

Target=[2;2;2;2;2;2;2;1;1;1;1;1;1;1];
Class = multisvm(Trainfea,Target,Testfea);
end